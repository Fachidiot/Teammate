import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';

class RegisterDetailPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const RegisterDetailPage({super.key, required this.userData});

  @override
  State<RegisterDetailPage> createState() => _RegisterDetailPageState();
}

class _RegisterDetailPageState extends State<RegisterDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _introController = TextEditingController();

  String? _selectedJob;
  bool _isLoading = false;
  XFile? _portfolioImage;
  XFile? _portfolioPdf;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) setState(() => _portfolioImage = result.files.single.xFile);
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) setState(() => _portfolioPdf = result.files.single.xFile);
  }

  void _onRegisterBtnClicked() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedJob == null) {
      _showJobNotSelectedDialog();
    } else {
      _processRegistration();
    }
  }

  void _showJobNotSelectedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text("알림", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "직군이 선택되지 않았습니다.\n직군은 나중에 [프로필] 메뉴에서\n언제든지 설정할 수 있습니다.\n\n이대로 가입을 진행하시겠습니까?",
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processRegistration();
            },
            child: const Text("확인", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _processRegistration() async {
    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.userData['email'],
        password: widget.userData['password'],
      );

      final newUser = {
        ...widget.userData,
        'uid': credential.user!.uid,
        'job': _selectedJob ?? '미설정',
        'introduction': _introController.text,
        'github': '',
        'code_score': 0,
        'design_score': 0,
        'plan_score': 0,
      };
      newUser.remove('password');

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(newUser);

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('가입 실패. 다시 시도해주세요.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("PROFILE SETUP", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("당신의 직군은\n무엇인가요?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, height: 1.2)),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(child: _buildJobCard("개발자", Icons.code)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildJobCard("디자이너", Icons.brush)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildJobCard("기획자", Icons.lightbulb_outline)),
                    ],
                  ),
                  const SizedBox(height: 40),

                  const Text("포트폴리오 & 소개", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 16),

                  if (_selectedJob == '디자이너') ...[
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), color: Colors.grey[50]),
                        child: _portfolioImage == null
                            ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate_outlined, color: Colors.grey), SizedBox(height: 8), Text("이미지 업로드", style: TextStyle(color: Colors.grey, fontSize: 12))])
                            : kIsWeb ? Image.network(_portfolioImage!.path, fit: BoxFit.cover) : Image.file(File(_portfolioImage!.path), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ] else if (_selectedJob == '기획자') ...[
                    GestureDetector(
                      onTap: _pickPdf,
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), color: Colors.grey[50]),
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                            const SizedBox(width: 16),
                            Expanded(child: Text(_portfolioPdf != null ? _portfolioPdf!.name : "기획서 업로드 (PDF)", style: const TextStyle(fontSize: 12))),
                            if (_portfolioPdf == null) const Icon(Icons.upload, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  TextFormField(
                    controller: _introController,
                    cursorColor: Colors.black,
                    decoration: _inputDecoration("간단한 자기소개", Icons.person_outline),
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? '소개를 입력해주세요' : null,
                  ),

                  const SizedBox(height: 50),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onRegisterBtnClicked,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1))
                          : const Text('가입 완료', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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

  Widget _buildJobCard(String label, IconData icon) {
    final bool isSelected = _selectedJob == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedJob == label) {
            _selectedJob = null;
            _portfolioImage = null;
            _portfolioPdf = null;
          } else {
            _selectedJob = label;
            _portfolioImage = null;
            _portfolioPdf = null;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(0),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
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