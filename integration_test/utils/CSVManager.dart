import 'dart:io';

import 'package:csv/csv.dart';

/// Clase para gestionar la carga y lectura de archivos CSV.
class CSVManager {
  final String filePath;

  CSVManager(this.filePath);

  Future<List<Map<String, dynamic>>> loadTestCases() async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final lines = content.split('\n');

      // Extraer encabezados (primera fila) y agregarles comillas dobles
      final headers =
          lines.first.split(',').map((header) => '"$header"').toList();

      // Mapear las líneas a Map<String, dynamic>
      final testCases =
          lines.skip(1).where((line) => line.isNotEmpty).map((line) {
        final values = line.split(',');
        // Crear el mapa con claves entre comillas
        return Map<String, dynamic>.fromIterables(headers, values);
      }).toList();

      // print('Datos del CSV cargados correctamente: $testCases');
      return testCases;
    } catch (e) {
      print('Error al cargar los datos del CSV: $e');
      return [];
    }
  }
}
