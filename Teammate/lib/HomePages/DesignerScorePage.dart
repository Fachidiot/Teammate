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
  XFile? _selectedFile;
  bool _isDragging = false;
  bool _isAnalyzing = false;
  bool _showResult = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.xFile;
        _showResult = false;
      });
    }
  }

  void _onDragDone(DropDoneDetails details) {
    if (details.files.isNotEmpty) {
      setState(() {
        _selectedFile = details.files.first;
        _showResult = false;
      });
    }
  }

  void _analyze() async {
    if (_selectedFile == null) return;
    print("[AI LOG] 디자인 분석 시작: ${_selectedFile!.name}");
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isAnalyzing = false;
      _showResult = true;
    });
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
            const Text("PORTFOLIO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 10),
            const Text("작품을\n업로드하세요", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black, height: 1.2)),
            const SizedBox(height: 40),

            DropTarget(
              onDragDone: _onDragDone,
              onDragEntered: (_) => setState(() => _isDragging = true),
              onDragExited: (_) => setState(() => _isDragging = false),
              child: GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    color: _isDragging ? Colors.grey[50] : Colors.white,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: _selectedFile == null
                      ? _buildEmptyView()
                      : _buildPreview(),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: (_selectedFile == null || _isAnalyzing) ? null : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  disabledBackgroundColor: Colors.grey[200],
                ),
                child: _isAnalyzing
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1))
                    : const Text("시각 분석 시작", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              ),
            ),

            const SizedBox(height: 40),

            if (_showResult)
              _buildResultModern(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("DRAG & DROP", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[400], letterSpacing: 2.0)),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        kIsWeb
            ? Image.network(_selectedFile!.path, fit: BoxFit.cover)
            : Image.file(File(_selectedFile!.path), fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.05)),
        Positioned(
          bottom: 20, left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.white,
            child: Text(
              _selectedFile!.name.toUpperCase(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
          ),
        ),
        Positioned(
          top: 20, right: 20,
          child: GestureDetector(
            onTap: () => setState(() { _selectedFile = null; _showResult = false; }),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: const Icon(Icons.close, size: 16, color: Colors.black),
            ),
          ),
        ),
      ],
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
            const Text("디자인 점수", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            Text("00", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100, color: Colors.grey[800], height: 1.0)),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "AI 분석 결과: 색채 조화와 레이아웃 균형이 우수합니다. 여백을 활용한 공간감이 돋보입니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.6, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}