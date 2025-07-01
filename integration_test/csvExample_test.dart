import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ces/main.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patrol/patrol.dart';

import 'utils/CSVManager.dart';

late List<Map<String, dynamic>> testCases;

void main() {
  setUpAll(() async {
    testCases = await loadTestCases();
    print('Casos de prueba cargados: $testCases');
  });

  patrolTest(
    'Pruebas de inicio de sesión y productos',
    (PatrolIntegrationTester $) async {
      for (final testCase in testCases) {
        final email = testCase['email'] as String;
        final password = testCase['password'] as String;
        final expectedProductCount =
            int.parse(testCase['expectedProductCount']);

        print('Ejecutando prueba: ${testCase['description']}');

        // Simulación de datos de usuario en local
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/registration.json');
        await file.writeAsString(json.encode([
          {'email': email, 'password': password}
        ]));

        await $.pumpWidgetAndSettle(const MyApp());

        // Interacción con la UI
        await $('Bienvenido a tu cuenta').waitUntilVisible();
        await $(#email_field).enterText(email);
        await $(#password_field).enterText(password);
        await $(#login_button).tap();
        await $.pumpAndSettle();

        // Verificación
        await $(Producto).waitUntilVisible();
        final Finder productoFinder = find.byType(Producto);
        expect(productoFinder, findsExactly(expectedProductCount));

        print('✅ Prueba completada para ${testCase['description']}');
      }
    },
  );
}

// Función para cargar los casos de prueba desde un CSV
Future<List<Map<String, dynamic>>> loadTestCases() async {
  try {
    final file = File(
        '/Users/nahuel/Desktop/flutter_application_1/flutter_ces/test/test_cases.csv');
    final content = await file.readAsString();
    final lines =
        content.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty) return [];

    final headers = lines.first.split(',').map((h) => h.trim()).toList();
    final testCases = lines.skip(1).map((line) {
      final values = line.split(',').map((v) => v.trim()).toList();
      final map = Map<String, dynamic>.fromIterables(headers, values);
      return map;
    }).toList();

    return testCases;
  } catch (e) {
    print('Error al cargar los datos del CSV: $e');
    return [];
  }
}
