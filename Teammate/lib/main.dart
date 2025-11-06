import 'package:flutter/material.dart';
import 'package:teammate/InitPage.dart';

void main() {
  runApp(const TeammateApp());
}

class TeammateApp extends StatelessWidget {
  const TeammateApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teammate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const InitPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
