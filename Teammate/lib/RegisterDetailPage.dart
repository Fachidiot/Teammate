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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

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
        // Remove password before saving to firestore
        newUser.remove('password');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set(newUser);

        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? '회원가입에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추가 정보 입력'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("간단한 자기소개를 적어주세요."),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _introController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '자기소개',
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '자기소개를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (widget.userData['job'] == '개발자') ...[
                    const Text("깃허브 링크를 적어놓을수 있는 textinput"),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _githubController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'https://github.com/your-username',
                      ),
                    ),
                  ] else if (widget.userData['job'] == '디자이너') ...[
                    const Text("작업물을 올릴수 있도록 이미지를 올리는 버튼"),
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement image picker
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('이미지 업로드'),
                    ),
                  ] else if (widget.userData['job'] == '기획자') ...[
                    const Text(".pdf파일등의 기획안 파일을 올릴수 있는 버튼"),
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement file picker for pdf
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('PDF 업로드'),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerClicked,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('회원가입'),
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
}
