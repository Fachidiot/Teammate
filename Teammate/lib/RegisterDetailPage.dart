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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('ADDITIONAL INFO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("추가 정보 입력", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _introController,
                    decoration: _inputDecoration("자기소개", Icons.description_outlined),
                    maxLines: 5,
                    validator: (v) => v!.isEmpty ? '자기소개를 입력해주세요' : null,
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                      controller: _githubController,
                      decoration: _inputDecoration("Github 주소 (선택)", Icons.link)
                  ),

                  const SizedBox(height: 50),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerClicked,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('가입 완료', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: Colors.white)),
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
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      prefixIcon: Icon(icon, color: Colors.black, size: 20),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
    );
  }
}