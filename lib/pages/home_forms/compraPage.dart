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
  final Producto producto;

  const CompraPage({required this.producto});

  @override
  Widget build(BuildContext context) {
    return _ProductPageTemplate(producto: producto);
  }
}

class _ProductPageTemplate extends StatelessWidget {
  final Producto producto;

  const _ProductPageTemplate({required this.producto});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

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
          SizedBox(width: 10)
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
        child: _ProductContent(producto: producto),
      ),
    );
  }
}

class _ProductContent extends StatelessWidget {
  final Producto producto;

  const _ProductContent({required this.producto});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Imagen del producto
          Container(
            width: width * 0.70,
            height: height * 0.30,
            child: Image.asset(producto.imagen),
          ),

          // Características del producto (puedes hacer esto dinámico también)
          _ProductFeatures(),

          // Botones de compra
          _PurchaseButtons(producto: producto),
        ],
      ),
    );
  }
}

class _ProductFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          _FeatureButton(
            icon: 'assets/microfono.svg',
            text: 'Built-In Microphone',
          ),
          SizedBox(width: Styles.buttonSpacing),
          _FeatureButton(
            icon: 'assets/audifono.svg',
            text: 'Headset Jack',
          ),
          SizedBox(width: Styles.buttonSpacing),
          _FeatureButton(
            icon: 'assets/sensor.svg',
            text: 'Motion Sensor',
          ),
        ],
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String icon;
  final String text;

  const _FeatureButton({
    required this.icon,
    required this.text,
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
            SvgPicture.asset(this.icon),
            Text(
              this.text,
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

class _PurchaseButtons extends StatelessWidget {
  final Producto producto;

  const _PurchaseButtons({required this.producto});

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
            onPressed: () => _showPurchaseOptions(context, producto),
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

// Funciones de utilidad
void _handleBack(BuildContext context) {
  Navigator.of(context).pop();
}

void _showPurchaseOptions(BuildContext context, Producto producto) {
  showBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            title: Text('Google Play'),
            leading: FaIcon(FontAwesomeIcons.googlePay),
            trailing: FaIcon(FontAwesomeIcons.moneyBill),
            onTap: () => _navigateToSummary(context, [producto]),
          ),
          ListTile(
            title: Text('Apple Play'),
            leading: FaIcon(FontAwesomeIcons.applePay),
            trailing: FaIcon(FontAwesomeIcons.moneyBill),
            onTap: () => _navigateToSummary(context, [producto]),
          ),
          ListTile(
            title: Text('Paypal'),
            leading: FaIcon(FontAwesomeIcons.paypal),
            trailing: FaIcon(FontAwesomeIcons.moneyBill),
            onTap: () => _navigateToSummary(context, [producto]),
          ),
        ],
      );
    },
  );
}

void _navigateToSummary(BuildContext context, List<Producto> productos) {
  Navigator.push(
    context,
    StackPagesRoute(
      previousPages: [CompraPage(producto: productos.first)],
      enterPage: CompraFormSummary(),
    ),
  );
}
