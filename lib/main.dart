import 'package:firebase_core/firebase_core.dart';
import 'pages/helpers/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ces/pages/home_forms/demo.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: CompraFormsDemo(),
    );
  }
}
