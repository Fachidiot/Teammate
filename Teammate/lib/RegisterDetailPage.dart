import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterDetailPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const RegisterDetailPage({super.key, required this.userData});

  @override
  State<RegisterDetailPage> createState() => _RegisterDetailPageState();
}

class _RegisterDetailPageState extends State<RegisterDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _githubController = TextEditingController();
  final _introController = TextEditingController();
  bool _isLoading = false;

  void _registerClicked() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.userData['email']!,
        password: widget.userData['password']!,
      );

      if (credential.user != null) {
        final newUser = {
          ...widget.userData,
          'uid': credential.user!.uid,
          'github': _githubController.text,
          'introduction': _introController.text,
        };
        newUser.remove('password');

        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(newUser);
        if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? '가입 실패')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('추가 정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("마지막 단계입니다!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _introController,
                    decoration: _inputDecoration("자기소개", Icons.description_outlined),
                    maxLines: 5,
                    validator: (v) => v!.isEmpty ? '자기소개를 입력해주세요' : null,
                  ),
                  const SizedBox(height: 16),

                  if (widget.userData['job'] == '개발자')
                    TextFormField(controller: _githubController, decoration: _inputDecoration("Github 주소", Icons.link)),

                  // 디자인/기획자용 버튼 (UI만 존재)
                  if (widget.userData['job'] != '개발자')
                    SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file), label: const Text("포트폴리오 업로드 (선택)")),
                    ),

                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerClicked,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('가입 완료', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
    );
  }
}