
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teammate/LoginPage.dart';

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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_db.json');
  }

  void _registerClicked() async {
    if (_formKey.currentState!.validate()) {
      final dbFile = await _localFile;
      List<dynamic> users = [];
      if (await dbFile.exists()) {
        final content = await dbFile.readAsString();
        if (content.isNotEmpty) {
          users = jsonDecode(content);
        }
      }

      final newUser = {
        ...widget.userData,
        'github': _githubController.text,
        'introduction': _introController.text,
      };

      users.add(newUser);
      await dbFile.writeAsString(jsonEncode(users));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입이 완료되었습니다.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추가 정보 입력'),
      ),
      body: Padding(
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
                const Text("깃허브 링크를 적어주세요."),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _githubController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'https://github.com/your-username',
                  ),
                ),
              ] else if (widget.userData['job'] == '디자이너') ...[
                const Text("작업물(이미지, pdf등)을 올려주세요."),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement image picker
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('이미지 업로드'),
                ),
              ] else if (widget.userData['job'] == '기획자') ...[
                const Text("작업물(기획안, pdf파일)을 올려주세요"),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement file picker for pdf
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('PDF 업로드'),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _registerClicked,
                  child: const Text('회원가입'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
