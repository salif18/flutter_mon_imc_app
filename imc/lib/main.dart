import 'package:flutter/material.dart';
import 'package:imc/utils/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const MyAppRoutes(),
    );
  }
}

