import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ces/main.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patrol/patrol.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'utils/CSVManager.dart';

/// Lista de casos de prueba declarados en el nivel superior
final testCases = [
  {
    'description': 'Caso 1',
    'email': 'yanis@email.com',
    'password': '123456',
    'expectedProductCount': 4,
  },
  {
    'description': 'Caso 2',
    'email': 'testuser@email.com',
    'password': 'password123',
    'expectedProductCount': 4,
  },
];

void main() {
  // Declara una prueba parametrizada para cada caso en la lista de pruebas
  for (final testCase in testCases) {
    patrolTest(
      testCase['description'] as String,
      (PatrolIntegrationTester $) async {
        final email = testCase['email'] as String;
        final password = testCase['password'] as String;
        final expectedProductCount = testCase['expectedProductCount'] as int;

        // Configura el entorno de prueba
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/registration.json');
        await file.writeAsString(json.encode([
          {'email': email, 'password': password}
        ]));

        WidgetsFlutterBinding.ensureInitialized();
        await $.pumpWidgetAndSettle(const MyApp());

        // Interactúa con la aplicación usando los parámetros
        await $('Bienvenido a tu cuenta').waitUntilVisible();
        await $(#email_field).enterText(email);
        await $(#password_field).enterText(password);
        await $(#login_button).tap();
        await $.pumpAndSettle();

        // Verifica los resultados según los parámetros
        await $(Producto).waitUntilVisible();
        final Finder productoFinder = find.byType(Producto);
        expect(productoFinder, findsExactly(expectedProductCount));
      },
    );
  }
}
