import 'package:flutter/material.dart';
import 'package:teammate/RegisterPage.dart';
import 'package:teammate/HomePages/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void registerClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void loginClicked() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("로그인"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "이메일",
                border: const OutlineInputBorder(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: () {},
                child: Text("비밀번호를 잊으셨나요?"),
              ),
            ),
            // Container(margin: EdgeInsets.only(top: 24), child: Text('OR')),
            // Container(
            //   margin: EdgeInsets.only(top: 24),
            //   child: Text("간편가입"),
            // ),
            // Container(
            //   margin: EdgeInsets.only(top: 48),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     spacing: 16,
            //     children: [
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           padding: EdgeInsets.zero, // 버튼 내부 패딩 제거
            //           backgroundColor: Colors.transparent, // 배경색 제거
            //           shadowColor: Colors.transparent, // 그림자 제거
            //         ),
            //         onPressed: () {},
            //         child: Image.asset('assets/images/g-logo.png', height: 50),
            //       ),
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           padding: EdgeInsets.zero, // 버튼 내부 패딩 제거
            //           backgroundColor: Colors.transparent, // 배경색 제거
            //           shadowColor: Colors.transparent, // 그림자 제거
            //         ),
            //         onPressed: () {},
            //         child: Image.asset('assets/images/g-logo.png', height: 50),
            //       ),
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           padding: EdgeInsets.zero, // 버튼 내부 패딩 제거
            //           backgroundColor: Colors.transparent, // 배경색 제거
            //           shadowColor: Colors.transparent, // 그림자 제거
            //         ),
            //         onPressed: () {},
            //         child: Image.asset('assets/images/g-logo.png', height: 50),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 24),
              height: 50,
              child: ElevatedButton(onPressed: loginClicked, child: Text("로그인")),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("계정이 필요하신가요?"),
                  TextButton(
                    onPressed: registerClicked,
                    child: Text("회원가입"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      // bottomNavigationBar: BottomNavigationBar(items: items),
    );
  }
}
