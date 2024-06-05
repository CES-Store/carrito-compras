import 'dart:convert';
import 'dart:io';

class JsonFileManager {
  final String filePath;

  JsonFileManager(this.filePath);

  Future<Map<String, dynamic>> readJson() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        return json.decode(jsonString);
      }
    } catch (e) {
      print('Error reading JSON file: $e');
    }
    return {};
  }

  Future<void> writeJson(Map<String, dynamic> data) async {
    try {
      final file = File(filePath);
      final jsonString = json.encode(data);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error writing to JSON file: $e');
    }
  }
}
