import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ces/pages/login_forms/signUpPage.dart';
import 'package:flutter_ces/pages/login_forms/splash.dart';
import 'package:path_provider/path_provider.dart';

import '../../components/stack_pages_route.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [Fondo(), Contenido()],
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Bienvenido a tu cuenta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Datos(),
        ],
      ),
    );
  }
}

class Datos extends StatefulWidget {
  const Datos({Key? key}) : super(key: key);

  @override
  State<Datos> createState() => _DatosState();
}

class _DatosState extends State<Datos> {
  bool obs = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _iniciarSesion() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registration.json');
      if (!await file.exists()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text('No hay usuarios registrados.'),
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

      final String jsonString = await file.readAsString();
      final List<dynamic> users = json.decode(jsonString);
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      for (var user in users) {
        if (user['email'] == email && user['password'] == password) {
          Navigator.push(
              context,
              StackPagesRoute(
                  previousPages: [LoginPage()], enterPage: SplashPage()));
          return;
        }
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error de inicio de sesión'),
          content:
              Text('El correo electrónico o la contraseña son incorrectos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    } catch (e) {
      print('Error al leer el archivo JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            key: Key('email_field'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            key: Key('password_field'),
            obscureText: obs,
            controller: _passwordController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      obs == true ? obs = false : obs = true;
                    });
                  },
                )),
          ),
          const Remember(),
          const SizedBox(
            height: 30,
          ),
          Botones(signInCallback: _iniciarSesion),
        ],
      ),
    );
  }
}

class Remember extends StatefulWidget {
  const Remember({super.key});

  @override
  State<Remember> createState() => _RememberState();
}

class _RememberState extends State<Remember> {
  bool valor = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: valor,
            onChanged: (value) {
              setState(() {
                valor == false ? valor = true : valor = false;
              });
            }),
        const Text('Recordarme'),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('Olvidaste la contrasena?'),
        ),
      ],
    );
  }
}

class Botones extends StatelessWidget {
  final void Function() signInCallback;

  const Botones({Key? key, required this.signInCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            key: Key('login_button'),
            onPressed: signInCallback,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xff142047)),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        const Text(
          'O entra con:',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        Container(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Sign with Google',
                style: TextStyle(
                  color: Color(0xff142047),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )),
        const SizedBox(),
        Container(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Sign with Facebook',
                style: TextStyle(
                  color: Color(0xff142047),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )),
        TextButton(
          onPressed: () {
            Navigator.push(
              context as BuildContext,
              StackPagesRoute(
                previousPages: [LoginPage()],
                enterPage: SignupPage(),
              ),
            );
          },
          child: const Text('Necesitas registrarte?'),
        ),
      ],
    );
  }
}

class Fondo extends StatelessWidget {
  const Fondo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.blue.shade300,
          Colors.blue,
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      )),
    );
  }
}
