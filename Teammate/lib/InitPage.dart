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
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void registerClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // === 로고 및 타이틀 영역 ===
              Center(
                child: Container(
                  width: 100, height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black, // 갤러리 느낌의 블랙 박스
                    shape: BoxShape.rectangle,
                  ),
                  child: Image.asset(
                    "assets/images/g-logo.png",
                    color: Colors.white,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.hub, size: 50, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "TEAMMATE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.0, // 자간을 넓혀서 고급스럽게
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "AI 기반 전문가 역량 분석 플랫폼",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),

              // 로그인 버튼 (Filled Black)
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: loginClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // 직각 버튼
                  ),
                  child: const Text("로그인", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ),
              ),
              const SizedBox(height: 16),

              // 회원가입 버튼 (Outlined)
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: registerClicked,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: const Text("회원가입", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.5)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}