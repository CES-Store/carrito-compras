import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/ces_logo_claro.png',
      nextScreen: ProductosPage(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
