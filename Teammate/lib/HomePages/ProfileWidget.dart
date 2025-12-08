import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const ProfileWidget(
      {super.key, required this.user, required this.onProfileUpdated});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _isEditing = false;
  bool _isSaving = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _introController;
  late TextEditingController _githubController;

  bool _receiveChats = true;
  bool _showProfile = true;

  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant ProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _initControllers();
    }
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.user['name']);
    _introController = TextEditingController(text: widget.user['introduction']);
    _githubController = TextEditingController(text: widget.user['github']);
    _receiveChats = widget.user['receiveChats'] ?? true;
    _showProfile = widget.user['showProfile'] ?? true;
    _pickedImage = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _introController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 800);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate() || _isSaving) {
      return;
    }
    setState(() {
      _isSaving = true;
    });

    try {
      final Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'introduction': _introController.text,
        'github': _githubController.text,
        'receiveChats': _receiveChats,
        'showProfile': _showProfile,
      };

      if (_pickedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(widget.user['uid']);
            
        UploadTask uploadTask;
        if (kIsWeb) {
          uploadTask = storageRef.putData(await _pickedImage!.readAsBytes());
        } else {
          uploadTask = storageRef.putFile(File(_pickedImage!.path));
        }

        final snapshot = await uploadTask;
        final photoURL = await snapshot.ref.getDownloadURL();
        updatedData['photoURL'] = photoURL;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user['uid'])
          .update(updatedData);

      final updatedUser = {...widget.user, ...updatedData};
      widget.onProfileUpdated(updatedUser);

      setState(() {
        _isEditing = false;
        _pickedImage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 저장되었습니다.')),
        );
      }
    } on FirebaseException catch (e) {
      String message = '프로필 저장에 실패했습니다.';
      if (e.code == 'unauthorized') {
        message =
            '오류: Storage 접근 권한이 없습니다. Firebase 콘솔에서 Storage의 규칙을 확인해주세요.';
      } else if (e.code == 'project-not-found' ||
          e.code == 'bucket-not-found') {
        message =
            '오류: Firebase 프로젝트 또는 Storage 버킷을 찾을 수 없습니다. Firebase 설정을 확인해주세요.';
      } else {
        message = 'Firebase 오류가 발생했습니다: ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알 수 없는 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void logoutClicked() async {
    await FirebaseAuth.instance.signOut();
    // The stream in main.dart will handle navigation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.0))
                  : const Icon(Icons.save),
              onPressed: _saveProfile,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logoutClicked,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;
            if (isWideScreen) {
              return _buildWideLayout();
            } else {
              return _buildNarrowLayout();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildProfileHeader(avatarRadius: 40),
        const SizedBox(height: 24),
        _buildGradeAndScore(),
        const SizedBox(height: 24),
        _buildStaticInfo(),
        const SizedBox(height: 24),
        _buildEditableContent(),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildProfileHeader(avatarRadius: 50),
              const SizedBox(height: 24),
              _buildGradeAndScore(),
              const SizedBox(height: 24),
              _buildStaticInfo(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: _buildEditableContent(),
        ),
      ],
    );
  }

  ImageProvider? _getAvatarImage() {
    if (_pickedImage != null) {
      return kIsWeb
          ? NetworkImage(_pickedImage!.path)
          : FileImage(File(_pickedImage!.path));
    }
    if (widget.user['photoURL'] != null && widget.user['photoURL'].isNotEmpty) {
      return NetworkImage(widget.user['photoURL']);
    }
    return null;
  }

  Widget _buildProfileHeader({required double avatarRadius}) {
    return Row(
      children: [
        GestureDetector(
          onTap: _isEditing ? _pickImage : null,
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundImage: _getAvatarImage(),
            child: _getAvatarImage() == null
                ? Icon(Icons.image_outlined,
                    size: avatarRadius, color: _isEditing ? Colors.white : Colors.grey)
                : null,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _isEditing
              ? TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '이름'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              : Text(
                  widget.user['name'],
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  Widget _buildGradeAndScore() {
    final String grade = widget.user['grade'] ?? 'N/A';
    final int score = widget.user['score'] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('등급', style: Theme.of(context).textTheme.titleMedium),
            Text(grade, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              Center(
                child: Text('$score', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStaticInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDisplayField('Email', widget.user['email'] ?? '-'),
        const SizedBox(height: 16),
        _buildDisplayField('Birthdate', widget.user['birthdate'] ?? '-'),
        const SizedBox(height: 16),
        _buildDisplayField('Gender', widget.user['gender'] ?? '-'),
        const SizedBox(height: 16),
        _buildDisplayField('포지션', widget.user['job'] ?? '-'),
      ],
    );
  }

  Widget _buildEditableContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isEditing) ...[
          TextFormField(
            controller: _introController,
            decoration: const InputDecoration(
                labelText: '내 프로필 문구', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          if (widget.user['job'] == '개발자')
            TextFormField(
              controller: _githubController,
              decoration: const InputDecoration(
                  labelText: '나의 외부 링크', border: OutlineInputBorder()),
            ),
        ] else ...[
          _buildDisplayField(
              '내 프로필 문구', widget.user['introduction'] ?? '-'),
          const SizedBox(height: 16),
          _buildDisplayField('나의 외부 링크', widget.user['github'] ?? '-'),
        ],
        const SizedBox(height: 32),
        _buildSwitchTile('채팅을 받습니다', _receiveChats,
            _isEditing ? (val) => setState(() => _receiveChats = val) : null),
        const SizedBox(height: 8),
        _buildSwitchTile('내 프로필을 노출합니다', _showProfile,
            _isEditing ? (val) => setState(() => _showProfile = val) : null),
      ],
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      ValueChanged<String?>? onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: onChanged == null,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, bool value, ValueChanged<bool>? onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
