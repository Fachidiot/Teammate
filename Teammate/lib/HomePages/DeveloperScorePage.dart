import 'package:flutter/material.dart';

class DeveloperScorePage extends StatefulWidget {
  const DeveloperScorePage({super.key});

  @override
  State<DeveloperScorePage> createState() => _DeveloperScorePageState();
}

class _DeveloperScorePageState extends State<DeveloperScorePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isAnalyzing = false;
  bool _showResult = false;

  void _startAnalysis() async {
    if (_urlController.text.isEmpty) return;
    FocusScope.of(context).unfocus();

    // 여기에 AI 검사 로직을 작성해주세요 ><

    setState(() {
      _isAnalyzing = true;
      _showResult = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
      });
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("저장소 주소", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 10),
            const Text("Github 코드\n분석 시작", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black, height: 1.2)),
            const SizedBox(height: 50),

            TextField(
              controller: _urlController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: "https://github.com/username/repo",
                hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 40),

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
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1))
                    : const Text("분석 시작", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              ),
            ),

            const SizedBox(height: 60),

            if (_showResult)
              _buildResultModern(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultModern() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("종합 점수", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            Text("00", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100, color: Colors.grey[800], height: 1.0)),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "이곳에 AI가 분석한 코드 품질, 아키텍처 효율성, 보안 취약점에 대한 상세 리포트가 표시됩니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.6, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}