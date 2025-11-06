import 'package:flutter/material.dart';
import 'package:teammate/RegisterPage.dart';
import 'package:teammate/LoginPage.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  void loginClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void registerClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 200),
              width: 128,
              child: Image(image: AssetImage("assets/images/g-logo.png")),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 24),
              height: 50,
              child: ElevatedButton(
                onPressed: loginClicked,
                child: Text("로그인"),
              ),
            ),
            Container(margin: EdgeInsets.only(top: 24), child: Text("OR")),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 24),
              height: 50,
              child: ElevatedButton(
                onPressed: registerClicked,
                child: Text("회원가입"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
