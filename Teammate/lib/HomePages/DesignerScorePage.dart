import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

class DesignerScorePage extends StatefulWidget {
  const DesignerScorePage({super.key});

  @override
  State<DesignerScorePage> createState() => _DesignerScorePageState();
}

class _DesignerScorePageState extends State<DesignerScorePage> {
  List<XFile> _files = [];
  bool _analyzing = false;
  Map<String, dynamic>? _result;

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
    if (res != null) setState(() { _files = res.files.map((e) => e.xFile).toList(); _result = null; });
  }

  void _analyze() async {
    if (_files.isEmpty) return;
    setState(() => _analyzing = true);

    // [AI 연동] 1. 이미지 파일 전송
    await Future.delayed(const Duration(seconds: 2));

    // [AI 연동] 2. JSON 응답
    final mock = {"total_score": 92, "summary": "색채 조화와 레이아웃 균형이 탁월합니다."};

    if (mounted) setState(() { _analyzing = false; _result = mock; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PORTFOLIO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            const Text("작품 업로드", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300)),
            const SizedBox(height: 40),
            DropTarget(
              onDragDone: (d) => setState(() { _files = d.files; _result = null; }),
              child: GestureDetector(
                onTap: _pick,
                child: Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
                  child: _files.isEmpty
                      ? const Center(child: Icon(Icons.add, color: Colors.grey))
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _files.length,
                    itemBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: kIsWeb ? Image.network(_files[i].path) : Image.file(File(_files[i].path)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: (_files.isEmpty || _analyzing) ? null : _analyze,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                child: _analyzing ? const CircularProgressIndicator(color: Colors.white) : Text("분석하기 (${_files.length})", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 40),
              const Divider(color: Colors.black),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("VISUAL SCORE", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${_result!['total_score']}", style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w100)),
              ]),
              Text(_result!['summary'], style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.grey)),
            ]
          ],
        ),
      ),
    );
  }
}