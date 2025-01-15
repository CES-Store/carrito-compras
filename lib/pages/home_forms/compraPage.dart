import 'package:flutter/material.dart';
import 'package:flutter_ces/components/stack_pages_route.dart';
import 'package:flutter_ces/pages/carrito_forms/carrito_provider.dart';
import 'package:flutter_ces/pages/compra_forms/compra_form_summary.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../styles/styles_home.dart';

class CompraPage extends StatelessWidget {
  final int imageIndex;

  const CompraPage({required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    switch (imageIndex) {
      case 1:
        return Page1();
        break;
      case 2:
        return Page2();
        break;
      case 3:
        return Page3();
        break;
      case 4:
        return Page4();
      default:
        return Container();
    }
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final producto = Producto(
      index: 1,
      nombre: 'PS5 Side',
      precio: 499.99,
      info: 'PlayStation 5 Digital Edition',
      imagen: 'assets/ps5_side.png',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _handleBack(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Styles.appBarIconColor,
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          'assets/ces_logo.png',
          width: width / Styles.appBarTitleWidthFraction,
        ),
        backgroundColor: Styles.pageAppBarBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
            color: Styles.appBarIconColor,
          ),
          SizedBox(
            width: 10,
          )
        ],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Styles.borderRadius),
            topRight: Radius.circular(Styles.borderRadius),
          ),
          color: Styles.bodyBackgroundColor,
        ),
        child: Contenido(imagen: 'assets/ps5_side.png', producto: producto),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final producto = Producto(
      index: 2,
      nombre: 'PS5',
      precio: 300,
      info: 'PlayStation 5 Digital Edition',
      imagen: 'assets/ps5.png',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _handleBack(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Styles.appBarIconColor,
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          'assets/ces_logo.png',
          width: width / Styles.appBarTitleWidthFraction,
        ),
        backgroundColor: Styles.pageAppBarBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
            color: Styles.appBarIconColor,
          ),
          SizedBox(
            width: 10,
          )
        ],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Styles.bodyBackgroundColor,
        ),
        child: Contenido(imagen: 'assets/ps5.png', producto: producto),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final producto = Producto(
      index: 3,
      nombre: 'Game console',
      precio: 70,
      info: 'Wireless Controller',
      imagen: 'assets/control.png',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _handleBack(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Styles.appBarIconColor,
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          'assets/ces_logo.png',
          width: width / Styles.appBarTitleWidthFraction,
        ),
        backgroundColor: Styles.pageAppBarBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
            color: Styles.appBarIconColor,
          ),
          SizedBox(
            width: 10,
          )
        ],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Styles.bodyBackgroundColor,
        ),
        child:
            Contenido(imagen: 'assets/control_compra.png', producto: producto),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({super.key});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final producto = Producto(
      index: 4,
      nombre: 'Game console',
      precio: 150,
      info: 'Wireless Headset',
      imagen: 'assets/audifono.png',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _handleBack(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Styles.appBarIconColor,
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          'assets/ces_logo.png',
          width: width / Styles.appBarTitleWidthFraction,
        ),
        backgroundColor: Styles.pageAppBarBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
            color: Styles.appBarIconColor,
          ),
          SizedBox(
            width: 10,
          )
        ],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Styles.bodyBackgroundColor,
        ),
        child: Contenido(imagen: 'assets/audifono.png', producto: producto),
      ),
    );
  }
}

class Contenido extends StatelessWidget {
  final String imagen;
  final Producto producto;

  const Contenido({super.key, required this.imagen, required this.producto});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: width * 0.70,
            height: height * 0.30,
            child: Image.asset(imagen),
          ),
          Botones(),
          Comprar(producto: producto),
        ],
      ),
    );
  }
}

class Botones extends StatelessWidget {
  const Botones({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          Boton(
            icono: 'assets/microfono.svg',
            texto: 'Built-In Microphone',
          ),
          SizedBox(
            width: Styles.buttonSpacing,
          ),
          Boton(
            icono: 'assets/audifono.svg',
            texto: 'Headset Jack',
          ),
          SizedBox(
            width: Styles.buttonSpacing,
          ),
          Boton(
            icono: 'assets/sensor.svg',
            texto: 'Motion Sensor',
          ),
        ],
      ),
    );
  }
}

class Comprar extends StatelessWidget {
  final Producto producto;

  const Comprar({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Styles.containerHeight,
      decoration: BoxDecoration(
        color: const Color(0xff142047).withOpacity(0.1),
        borderRadius: BorderRadius.circular(Styles.containerBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<CarritoProvider>(context, listen: false)
                  .agregarProducto(producto);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Producto agregado correctamente'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            label: Text(''),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: const Color(0xff142047),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              opcionCompra(context);
            },
            icon: Icon(Icons.attach_money, color: Colors.white),
            label: Text(''),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: const Color(0xff142047),
            ),
          ),
        ],
      ),
    );
  }
}

class Boton extends StatelessWidget {
  final String icono;
  final String texto;

  const Boton({
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Styles.width,
      height: Styles.height,
      decoration: BoxDecoration(
        color: Styles.backgroundColorBoton,
        borderRadius: BorderRadius.circular(Styles.borderRadiusBoton),
        boxShadow: [
          BoxShadow(
            color: Styles.shadowColor,
            offset: Offset(Styles.shadowOffsetX, Styles.shadowOffsetY),
            spreadRadius: Styles.shadowSpreadRadius,
            blurRadius: Styles.shadowBlurRadius,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              this.icono,
            ),
            Text(
              this.texto,
              style: TextStyle(
                color: Styles.textColorBoton,
                fontWeight: Styles.textFontWeightBoton,
                fontSize: Styles.textSizeBoton,
              ),
            )
          ],
        ),
      ),
    );
  }
}

PersistentBottomSheetController<dynamic> opcionCompra(BuildContext context) {
  return showBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            title: Text('Google Play'),
            leading: FaIcon(FontAwesomeIcons.googlePay),
            trailing: FaIcon(FontAwesomeIcons.moneyBill),
            onTap: () => _handleSubmit(context),
          ),
          ListTile(
            title: Text('Apple Play'),
            leading: FaIcon(FontAwesomeIcons.applePay),
            trailing: FaIcon(FontAwesomeIcons.moneyBill),
            onTap: () => _handleSubmit(context),
          ),
          ListTile(
            title: Text('Paypal'),
            leading: FaIcon(FontAwesomeIcons.paypal),
            trailing: FaIcon(
              FontAwesomeIcons.moneyBill,
            ),
            onTap: () => _handleSubmit(context),
          ),
        ],
      );
    },
  );
}

void _handleSubmit(BuildContext context) {
  Navigator.push(
    context,
    StackPagesRoute(
      previousPages: [CompraPage(imageIndex: 1)],
      enterPage: CompraFormSummary(),
    ),
  );
}

void _handleBack(BuildContext context) {
  Navigator.of(context).pop();
}
