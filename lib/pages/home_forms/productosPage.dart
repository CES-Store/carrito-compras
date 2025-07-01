import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ces/pages/carrito_forms/carritoPage.dart';
import 'package:flutter_ces/pages/home_forms/compraPage.dart';
import 'package:flutter_ces/pages/login_forms/loginPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/stack_pages_route.dart';
import 'package:flutter_ces/styles/styles_home.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Producto> _productos = [];
  List<Producto> _filteredProductos = [];
  bool _showAccountPage = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    try {
      final String data = await rootBundle.loadString('assets/productos.json');
      final jsonList = json.decode(data) as List<dynamic>;

      setState(() {
        _productos = jsonList.map((json) => Producto.fromJson(json)).toList();
        _filteredProductos = _productos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando productos: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterProductos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProductos = _productos;
      } else {
        _filteredProductos = _productos.where((producto) {
          final productoLower = producto.info.toLowerCase();
          final queryLower = query.toLowerCase();
          return productoLower.contains(queryLower);
        }).toList();
      }
    });
  }

  void _toggleAccountPage() {
    setState(() {
      _showAccountPage = !_showAccountPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu),
          color: Styles.appBarLeadingIconColor,
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Styles.appBarTitleImage,
        backgroundColor: Styles.appBarBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
            color: Styles.appBarActionsColor,
          ),
          SizedBox(width: 10),
        ],
        elevation: Styles.appBarElevation,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !_showAccountPage,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredProductos.isEmpty
                    ? Center(child: Text('No se encontraron productos'))
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: ProductosList(
                          productos: _filteredProductos,
                          onProductoTap: _navigateToCompraPage,
                        ),
                      ),
          ),
          Visibility(
            visible: _showAccountPage,
            child: AccountPage(onClose: _toggleAccountPage),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      bottomNavigationBar: Bottom(
        onSearchChanged: _filterProductos,
        onAccountPressed: _toggleAccountPage,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  void _navigateToCompraPage(Producto producto) {
    Navigator.push(
      context,
      StackPagesRoute(
        previousPages: [ProductosPage()],
        enterPage: CompraPage(producto: producto),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.push(
      context,
      StackPagesRoute(
        previousPages: [ProductosPage()],
        enterPage: LoginPage(),
      ),
    );
  }
}

class ProductosList extends StatelessWidget {
  final List<Producto> productos;
  final Function(Producto) onProductoTap;

  const ProductosList({
    Key? key,
    required this.productos,
    required this.onProductoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < productos.length; i += 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (i < productos.length)
                  _buildProductoItem(context, productos[i]),
                if (i + 1 < productos.length)
                  _buildProductoItem(context, productos[i + 1]),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProductoItem(BuildContext context, Producto producto) {
    return GestureDetector(
      onTap: () => onProductoTap(producto),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: Styles.productoDecoration,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: Hero(
                    tag: 'producto-${producto.index}',
                    child: Image.asset(
                      producto.imagen,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto.nombre, style: Styles.nombreTextStyle),
                    Text(producto.info, style: Styles.infoTextStyle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Bottom extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onAccountPressed;

  const Bottom({
    required this.onSearchChanged,
    required this.onAccountPressed,
    Key? key,
  }) : super(key: key);

  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      alignment: Alignment.center,
      width: double.infinity,
      height: _showSearchBar ? 150 : 100,
      decoration: const BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          if (_showSearchBar)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onChanged: widget.onSearchChanged,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home,
                    color: Styles.iconColor, size: Styles.iconSize),
              ),
              IconButton(
                onPressed: () =>
                    setState(() => _showSearchBar = !_showSearchBar),
                icon: Icon(Icons.search,
                    color: Styles.iconColor, size: Styles.iconSize),
              ),
              IconButton(
                onPressed: widget.onAccountPressed,
                icon: Icon(Icons.account_circle_outlined,
                    color: Styles.iconColor, size: Styles.iconSize),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    StackPagesRoute(
                      previousPages: [ProductosPage()],
                      enterPage: CarritoPage(),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_cart_outlined,
                    color: Styles.iconColor, size: Styles.iconSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Producto extends StatelessWidget {
  final int index;
  final String imagen;
  final String nombre;
  final String info;
  final num precio;
  final List<Map<String, String>>? features;
  int cantidad;

  Producto({
    required this.index,
    required this.imagen,
    required this.nombre,
    required this.info,
    required this.precio,
    this.features,
    this.cantidad = 1,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      index: json['index'],
      imagen: json['imagen'],
      nombre: json['nombre'],
      info: json['info'],
      precio: json['precio'],
      features: json['features'] != null
          ? List<Map<String, String>>.from(json['features'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'imagen': imagen,
      'nombre': nombre,
      'info': info,
      'precio': precio,
      'features': features,
      'cantidad': cantidad,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      child: Container(
        width: width * 0.35,
        height: height * 0.35,
        decoration: Styles.productoDecoration,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: width * 0.24,
                  height: height * 0.24,
                  child: Hero(
                    tag: 'producto-$index',
                    child: Image.asset(
                      imagen,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: Styles.nombreTextStyle),
                    Text(info, style: Styles.infoTextStyle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Producto copyWith({
    int? index,
    String? imagen,
    String? nombre,
    String? info,
    num? precio,
    List<Map<String, String>>? features,
    int? cantidad,
  }) {
    return Producto(
      index: index ?? this.index,
      imagen: imagen ?? this.imagen,
      nombre: nombre ?? this.nombre,
      info: info ?? this.info,
      precio: precio ?? this.precio,
      features: features ?? this.features,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Producto &&
        other.index == index &&
        other.imagen == imagen &&
        other.nombre == nombre &&
        other.info == info &&
        other.precio == precio;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        imagen.hashCode ^
        nombre.hashCode ^
        info.hashCode ^
        precio.hashCode;
  }
}

class AccountPage extends StatefulWidget {
  final VoidCallback onClose;

  AccountPage({required this.onClose});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _DateNacController = TextEditingController();
  final TextEditingController _NombreController = TextEditingController();
  final TextEditingController _ApellidoController = TextEditingController();
  final TextEditingController _TelefonoController = TextEditingController();
  final TextEditingController _DireccionController = TextEditingController();
  final TextEditingController _PaisController = TextEditingController();

  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserEmail();
  }

  Future<void> _loadCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserEmail = prefs.getString('current_user_email');
    if (_currentUserEmail != null) {
      _loadUserData(_currentUserEmail!);
    }
  }

  Future<void> _loadUserData(String email) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registration.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        final data = json.decode(contents) as List<dynamic>;

        final currentUser = data.firstWhere(
          (user) => user['email'] == email,
          orElse: () => null,
        );

        if (currentUser != null) {
          if (currentUser.containsKey('perfil')) {
            _NombreController.text = currentUser['perfil']['nombre'] ?? '';
            _ApellidoController.text = currentUser['perfil']['apellido'] ?? '';
            _DateNacController.text = currentUser['perfil']['fecNac'] ?? '';
            _DireccionController.text =
                currentUser['perfil']['direccion'] ?? '';
            _PaisController.text = currentUser['perfil']['pais'] ?? '';
          }
        }
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

  Future<void> _saveUserProfile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registration.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        final data = json.decode(contents) as List<dynamic>;

        final currentUserIndex = data.indexWhere(
          (user) => user['email'] == _currentUserEmail,
        );

        if (currentUserIndex != -1) {
          data[currentUserIndex]['perfil'] = {
            'nombre': _NombreController.text,
            'apellido': _ApellidoController.text,
            'fecNac': _DateNacController.text,
            'direccion': _DireccionController.text,
            'pais': _PaisController.text,
          };

          await file.writeAsString(json.encode(data));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil actualizado correctamente')),
          );
        }
      }
    } catch (e) {
      print('Error al guardar el perfil del usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Cuenta'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: widget.onClose,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _NombreController,
                decoration: InputDecoration(
                    hintText: "Nombre",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff142047).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.person)),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _ApellidoController,
                decoration: InputDecoration(
                    hintText: "Apellido",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff142047).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.person_2)),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _TelefonoController,
                decoration: InputDecoration(
                    hintText: "Telefono",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff142047).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.phone)),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _DateNacController,
                decoration: InputDecoration(
                    hintText: "Fecha de Nacimiento",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff142047).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.calendar_month)),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _DireccionController,
                decoration: InputDecoration(
                    hintText: "Direccion",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff142047).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.house)),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _PaisController,
                decoration: InputDecoration(
                    hintText: "Pais",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff142047).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.location_pin)),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserProfile,
                  child: const Text(
                    "Guardar",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    backgroundColor: const Color(0xff142047),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
