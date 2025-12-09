import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeveloperScorePage extends StatefulWidget {
  const DeveloperScorePage({super.key});

  @override
  State<DeveloperScorePage> createState() => _DeveloperScorePageState();
}

class _DeveloperScorePageState extends State<DeveloperScorePage> {
  final _urlController = TextEditingController();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _aiResult;

  void _startAnalysis() async {
    if (_urlController.text.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() { _isAnalyzing = true; _aiResult = null; });

    // 이곳에 ai 검사 로직을 넣으시면 됩니다
    await Future.delayed(const Duration(seconds: 2));

    final mock = {
      "total_score": 85,
      "summary": "코드 모듈화가 우수하며 가독성이 높습니다. 에러 처리를 보강하면 완벽합니다.",
    };

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'code_score': mock['total_score'],
        'code_comment': mock['summary'],
        'github': _urlController.text,
      });
    }

    if (mounted) setState(() { _isAnalyzing = false; _aiResult = mock; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("REPOSITORY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            const Text("Github 코드\n정밀 분석", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300)),
            const SizedBox(height: 50),

            TextField(
              controller: _urlController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: "Github URL",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: "https://github.com/...",
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _startAnalysis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: _isAnalyzing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1))
                    : const Text("분석 시작", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              ),
            ),

            if (_aiResult != null) ...[
              const SizedBox(height: 60),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL SCORE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  Text("${_aiResult!['total_score']}", style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w100)),
                ],
              ),
              const SizedBox(height: 20),
              Text(_aiResult!['summary'], style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.grey)),
            ]
          ],
        ),
      ),
    );
  }
}