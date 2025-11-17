import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammate/HomePages/HomePage.dart';
import 'package:teammate/InitPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userString = prefs.getString('user');
  Widget home = const InitPage();

  if (isLoggedIn && userString != null) {
    final user = jsonDecode(userString);
    home = HomePage(user: user);
  }

  runApp(TeammateApp(home: home));
}

class TeammateApp extends StatelessWidget {
  final Widget home;
  const TeammateApp({super.key, required this.home});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teammate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
