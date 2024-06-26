import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ces/components/stack_pages_route.dart';
import 'package:flutter_ces/pages/login_forms/loginPage.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Registrar",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Crea tu cuenta",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color(0xff142047).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email)),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color(0xff142047).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () => _signUp(context),
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xff142047),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Ya tienes cuenta?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            StackPagesRoute(
                              previousPages: [SignupPage()],
                              enterPage: LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.purple),
                        ))
                  ],
                )
              ],
            ),
          ),
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
              onPressed: () => Navigator.push(
                context,
                StackPagesRoute(
                  previousPages: [SignupPage()],
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

  Future<bool> isEmailRegistered(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/registration.json');

    if (await file.exists()) {
      final jsonData = json.decode(await file.readAsString());
      for (var record in jsonData) {
        if (record['email'] == email) {
          return true;
        }
      }
    }
    return false;
  }

  void _signUp(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Verificar si el correo electrónico ya está registrado
    if (await isEmailRegistered(email)) {
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

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registration.json');

      // Crear el archivo JSON si no existe
      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      // Leer el contenido actual del archivo JSON
      List<dynamic> data = [];
      if (await file.length() > 0) {
        data = json.decode(await file.readAsString());
      }

      // Agregar los nuevos datos de registro al archivo JSON
      data.add({'email': email, 'password': password});
      await file.writeAsString(json.encode(data));

      // Mostrar un mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registro exitoso'),
          content: Text('¡Tu cuenta ha sido registrada correctamente!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                StackPagesRoute(
                  previousPages: [SignupPage()],
                  enterPage: LoginPage(),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );

      // Limpiar los campos de entrada
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      print('Error al registrar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Hubo un error al registrar. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }
}
