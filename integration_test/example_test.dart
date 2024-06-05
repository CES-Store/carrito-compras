import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ces/main.dart';
import 'package:flutter_ces/pages/helpers/firebase_options.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'PruebaConcepto',
    (PatrolIntegrationTester $) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await $.pumpWidgetAndSettle(MyApp());
      await $('Bienvenido a tu cuenta').waitUntilVisible();
      await $(#email_field).enterText("otro@email.com");
      await $(#password_field).enterText("123456");
      await $(#login_button).tap();
      await $(Producto).waitUntilVisible().timeout(10 as Duration);
      //expect(Productos, findsOneWidget);
    },
  );
}
