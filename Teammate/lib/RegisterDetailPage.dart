import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  FilePickerResult? _pickedPortfolioFile;

  Future<void> _pickPortfolio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _pickedPortfolioFile = result;
      });
    }
  }

  // Simulate AI grading based on user data
  Future<Map<String, dynamic>> _getAIGrade() async {
    // In a real app, you would make an API call to your AI backend here.
    // For now, we'll just generate a random grade.
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    final random = Random();
    final score = 60 + random.nextInt(41); // Generates a score between 60 and 100

    String grade;
    if (score >= 95) {
      grade = 'S';
    } else if (score >= 90) {
      grade = 'A';
    } else if (score >= 80) {
      grade = 'B';
    } else if (score >= 70) {
      grade = 'C';
    } else {
      grade = 'D';
    }

    return {
      'grade': grade,
      'score': score,
    };
  }

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

        String? portfolioUrl;
        if (_pickedPortfolioFile != null) {
          final file = _pickedPortfolioFile!.files.first;
          final ref = FirebaseStorage.instance
              .ref('portfolios/${credential.user!.uid}/${file.name}');

          UploadTask uploadTask;
          if (kIsWeb) {
            final fileBytes = file.bytes;
            uploadTask = ref.putData(fileBytes!);
          } else {
            final filePath = file.path;
            uploadTask = ref.putFile(File(filePath!));
          }
          final snapshot = await uploadTask;
          portfolioUrl = await snapshot.ref.getDownloadURL();
        }

        if (portfolioUrl != null) {
          newUser['portfolioUrl'] = portfolioUrl;
        }

        // Get AI Grade and add it to the user data
        final aiGrade = await _getAIGrade();
        newUser['grade'] = aiGrade['grade'];
        newUser['score'] = aiGrade['score'];

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
                    const Text("깃허브 닉네임을 적어주세요."),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _githubController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'your-username',
                      ),
                    ),
                  ] else if (widget.userData['job'] == '디자이너' ||
                      widget.userData['job'] == '기획자') ...[
                    const Text("포트폴리오를 업로드해주세요 (이미지 또는 PDF).."),
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _pickPortfolio,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('파일 선택'),
                    ),
                    if (_pickedPortfolioFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            '선택된 파일: ${_pickedPortfolioFile!.files.first.name}'),
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
