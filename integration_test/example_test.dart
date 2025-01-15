import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ces/main.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'PruebaConcepto',
    (PatrolIntegrationTester $) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registration.json');
      await file.writeAsString(json.encode([
        {'email': 'yanis@email.com', 'password': '123456'}
      ]));
      WidgetsFlutterBinding.ensureInitialized();
      await $.pumpWidgetAndSettle(const MyApp());
      await $('Bienvenido a tu cuenta').waitUntilVisible();
      await $(#email_field).enterText("yanis@email.com");
      await $(#password_field).enterText("123456");
      await $(#login_button).tap();
      await $.pumpAndSettle();
      await $(Producto).waitUntilVisible();
      final Finder productoFinder = find.byType(Producto);
      expect(productoFinder, findsExactly(4));
    },
  );
}
