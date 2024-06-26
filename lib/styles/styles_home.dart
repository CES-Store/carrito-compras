import 'package:flutter/material.dart';

class Styles {
  //AppBar Styles
  static final appBarLeadingIconColor = Colors.black;
  static final appBarBackgroundColor = Colors.white;
  static final appBarElevation = 0.0;
  static final appBarTitleImageWidthRatio = 1 / 3;
  static final appBarTitleImage = Image.asset('assets/ces_logo_claro.png');
  static final appBarActionsColor = Colors.black;

  //Producto Styles
  static final BoxDecoration productoDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade200,
        offset: Offset(2, 2),
        spreadRadius: 5,
        blurRadius: 5,
      ),
    ],
  );
  static final TextStyle nombreTextStyle = TextStyle(fontSize: 8);
  static final TextStyle infoTextStyle =
      TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16);

  //Bottom Styles
  static const Color backgroundColor = Color(0xff21262E);
  static const Color iconColor = Colors.white;
  static const double iconSize = 30.0;

  //Page Styles
  static const Color pageAppBarBackgroundColor = Color(0xff21262E);
  static const Color appBarIconColor = Colors.white;
  static const double appBarTitleWidthFraction = 3;
  static const double borderRadius = 40;
  static const Color bodyBackgroundColor = Color(0xffEDF1F9);

  //Botones Styles
  static const double buttonSpacing = 20;

  //Comprar Styles
  static const double containerHeight = 80;
  static const double containerWidth = 130;
  static const double containerBorderRadius = 40;
  static const Color containerColor = Colors.blue;
  static Color containerChildColor = Colors.blue.shade700;
  static const Color textColor = Colors.white;
  static const FontWeight textFontWeight = FontWeight.w600;
  static const double textSize = 25;

  //Boton Styles
  static const double width = 150;
  static const double height = 150;
  static const Color backgroundColorBoton = Colors.white70;
  static const double borderRadiusBoton = 30;
  static const Color shadowColor = Colors.grey;
  static const double shadowOffsetX = 2;
  static const double shadowOffsetY = 2;
  static const double shadowSpreadRadius = 5;
  static const double shadowBlurRadius = 5;
  static const Color textColorBoton = Colors.black;
  static const FontWeight textFontWeightBoton = FontWeight.bold;
  static const double textSizeBoton = 16;
}
