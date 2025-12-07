import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onProfileUpdated;
  const ProfileWidget({super.key, required this.user, required this.onProfileUpdated});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('내 프로필', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 16)),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black, size: 20),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      image: widget.user['photoURL'] != null
                          ? DecorationImage(image: NetworkImage(widget.user['photoURL']), fit: BoxFit.cover)
                          : null
                  ),
                  child: widget.user['photoURL'] == null ? const Icon(Icons.person, color: Colors.grey) : null,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user['name'] ?? '사용자', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(widget.user['job'] ?? '직군 미설정', style: TextStyle(fontSize: 14, color: Colors.grey[600], letterSpacing: 1.0)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 40),

            const Text("AI 역량 분석", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 24),
            _buildStatRow("코드 품질", 0.0),
            const SizedBox(height: 16),
            _buildStatRow("시각 감각", 0.0),
            const SizedBox(height: 16),
            _buildStatRow("기획 논리", 0.0),

            const SizedBox(height: 40),
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 40),

            const Text("연락처 정보", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            Text(widget.user['email'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, double value) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            color: Colors.black,
            minHeight: 4,
          ),
        ),
        const SizedBox(width: 16),
        Text("00", style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.bold)),
      ],
    );
  }
}