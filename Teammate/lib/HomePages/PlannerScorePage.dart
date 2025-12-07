import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

class PlannerScorePage extends StatefulWidget {
  const PlannerScorePage({super.key});

  @override
  State<PlannerScorePage> createState() => _PlannerScorePageState();
}

class _PlannerScorePageState extends State<PlannerScorePage> {
  XFile? _selectedFile;
  bool _isDragging = false;
  bool _isAnalyzing = false;
  bool _showResult = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.xFile;
        _showResult = false;
      });
    }
  }

  void _onDragDone(DropDoneDetails details) {
    if (details.files.first.name.toLowerCase().endsWith('.pdf')) {
      setState(() {
        _selectedFile = details.files.first;
        _showResult = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PDF 파일만 가능합니다.")));
    }
  }

  void _analyze() async {
    if (_selectedFile == null) return;
    print("[AI LOG] 기획서 분석 시작: ${_selectedFile!.name}");
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
            const Text("DOCUMENTATION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 10),
            const Text("기획서(PDF)\n논리 분석", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black, height: 1.2)),
            const SizedBox(height: 40),

            DropTarget(
              onDragDone: _onDragDone,
              onDragEntered: (_) => setState(() => _isDragging = true),
              onDragExited: (_) => setState(() => _isDragging = false),
              child: GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: _isDragging ? Colors.grey[50] : Colors.white,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: _selectedFile == null ? _buildEmptyView() : _buildFileView(),
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
                    : const Text("논리 검증 시작", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              ),
            ),

            const SizedBox(height: 40),
            if (_showResult) _buildResultModern(),
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
          Icon(Icons.description_outlined, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("UPLOAD PDF", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[400], letterSpacing: 2.0)),
        ],
      ),
    );
  }

  Widget _buildFileView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 40, color: Colors.black),
          const SizedBox(height: 16),
          Text(_selectedFile!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() => _selectedFile = null),
            child: const Text("파일 제거", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.0)),
          )
        ],
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
            const Text("논리 점수", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            Text("00", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100, color: Colors.grey[800], height: 1.0)),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "AI 분석 결과: 기획 의도가 명확하고 논리적 흐름이 자연스럽습니다. MECE 구조를 잘 따르고 있습니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.6, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}