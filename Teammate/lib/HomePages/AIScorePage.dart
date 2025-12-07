import 'package:flutter/material.dart';
import 'DeveloperScorePage.dart';
import 'DesignerScorePage.dart';
import 'PlannerScorePage.dart';

class AIScorePage extends StatelessWidget {
  const AIScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('COMPETENCY', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.5, fontSize: 16)),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("직군을\n선택해주세요.", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300, height: 1.2, color: Colors.black, letterSpacing: -1.0)),
            const SizedBox(height: 16),
            Container(width: 40, height: 2, color: Colors.black),
            const SizedBox(height: 60),
            _buildCard(context, "01", "개발자", "Github 코드 & 아키텍처", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeveloperScorePage()))),
            const SizedBox(height: 24),
            _buildCard(context, "02", "디자이너", "시각적 조화 & 트렌드", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DesignerScorePage()))),
            const SizedBox(height: 24),
            _buildCard(context, "03", "기획자", "논리 구조 & 기획력", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlannerScorePage()))),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String num, String title, String desc, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]),
        child: Row(
          children: [
            Text(num, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(width: 24),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(desc, style: const TextStyle(fontSize: 14, color: Colors.grey))])),
            const Icon(Icons.arrow_forward, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }
}