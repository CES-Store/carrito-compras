import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ces/components/jsonFileManager.dart';

import '../../components/stack_pages_route.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrarse'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

 Future<void> _register() async {
  final String jsonString = await rootBundle.loadString('assets/users.json');
  final Map<String, dynamic> users = json.decode(jsonString);
  try {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    if (users.containsKey(email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error de registro'),
          content: Text('El correo electrónico ya está registrado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    final file = File('assets/users.json');
    users[email] = password;
    final updatedJsonString = json.encode(users);
    await file.writeAsString(updatedJsonString);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registro exitoso'),
        content: Text('¡Tu cuenta ha sido registrada correctamente!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, StackPagesRoute(
          previousPages: [RegisterPage()],
          enterPage: LoginPage(),
        ),
      ),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    print('Error al leer/escribir el archivo JSON: $e');
  }
}
}
