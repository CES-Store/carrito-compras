import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  List<Producto> _productos = [
    Producto(
      index: 1,
      imagen: 'assets/ps5_side.png',
      nombre: 'Game console',
      info: 'PlayStation 5 Digital Edition',
      precio: 0,
    ),
    Producto(
      index: 2,
      imagen: 'assets/ps5.png',
      nombre: 'Game console',
      info: 'PlayStation 5',
      precio: 0,
    ),
    Producto(
      index: 3,
      imagen: 'assets/control.png',
      nombre: 'Game console',
      info: 'Dual Sense Wireless Controller',
      precio: 0,
    ),
    Producto(
      index: 4,
      imagen: 'assets/audifono.png',
      nombre: 'Game console',
      info: 'Wireless Headset',
      precio: 0,
    ),
  ];
  List<Producto> _filteredProductos = [];
  bool _showAccountPage = false;

  @override
  void initState() {
    super.initState();
    _filteredProductos = _productos;
  }

  void _filterProductos(String query) {
    setState(() {
      _filteredProductos = _productos.where((producto) {
        final productoLower = producto.info.toLowerCase();
        final queryLower = query.toLowerCase();
        return productoLower.contains(queryLower);
      }).toList();
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
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
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
          SizedBox(
            width: 10,
          ),
        ],
        elevation: Styles.appBarElevation,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !_showAccountPage,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ProductosList(productos: _filteredProductos),
            ),
          ),
          Visibility(
            visible: _showAccountPage,
            child: AccountPage(onClose: _toggleAccountPage),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottom(
        onSearchChanged: (query) {
          _filterProductos(query);
        },
        onAccountPressed: _toggleAccountPage,
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

  const ProductosList({Key? key, required this.productos}) : super(key: key);

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
                if (i < productos.length) productos[i],
                if (i + 1 < productos.length) productos[i + 1],
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
  int cantidad;

  Producto({
    required this.index,
    required this.imagen,
    required this.nombre,
    required this.info,
    required this.precio,
    this.cantidad = 1,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => _handleSubmit(context, this.index),
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
                    tag: 'control',
                    child: Image.asset(
                      this.imagen,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.nombre, style: Styles.nombreTextStyle),
                    Text(this.info, style: Styles.infoTextStyle),
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

void _handleSubmit(BuildContext context, int index) {
  Navigator.push(
    context,
    StackPagesRoute(
      previousPages: [ProductosPage()],
      enterPage: CompraPage(
        imageIndex: index,
      ),
    ),
  );
}

class Bottom extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onAccountPressed;

  Bottom({required this.onSearchChanged, required this.onAccountPressed});

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
                icon: Icon(
                  Icons.home,
                  color: Styles.iconColor,
                  size: Styles.iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showSearchBar = !_showSearchBar;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: Styles.iconColor,
                  size: Styles.iconSize,
                ),
              ),
              IconButton(
                onPressed: widget.onAccountPressed,
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Styles.iconColor,
                  size: Styles.iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    StackPagesRoute(
                      previousPages: [CompraPage(imageIndex: 1)],
                      enterPage: CarritoPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Styles.iconColor,
                  size: Styles.iconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
