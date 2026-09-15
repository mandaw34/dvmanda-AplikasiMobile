import 'package:flutter/material.dart';
import 'kalkulator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KalkulatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}