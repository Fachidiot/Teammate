import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const ProfileWidget({super.key, required this.user, required this.onProfileUpdated});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _introController;
  late TextEditingController _githubController;

  String? _selectedPosition;
  final List<String> _positions = ['개발자', '디자이너', '기획자'];
  String? _selectedAbility;
  final List<String> _abilities = ['상', '중', '하'];
  bool _receiveChats = true;
  bool _showProfile = true;

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
    _selectedPosition = widget.user['job'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _introController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameController.text,
        'introduction': _introController.text,
        'github': _githubController.text,
        'job': _selectedPosition,
        // TODO: Save other fields like ability, chat settings etc.
      };

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user['uid'])
            .update(updatedData);

        final updatedUser = {...widget.user, ...updatedData};
        widget.onProfileUpdated(updatedUser);

        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 저장되었습니다.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 저장에 실패했습니다: $e')),
        );
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
              icon: const Icon(Icons.save),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.image_outlined, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _isEditing
                        ? TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: '이름'),
                          )
                        : Text(
                            widget.user['name'],
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Email: ${widget.user['email']}'),
              const SizedBox(height: 16),
              Text('Birthdate: ${widget.user['birthdate']}'),
              const SizedBox(height: 16),
              Text('Gender: ${widget.user['gender']}'),
              const SizedBox(height: 24),
              _buildDropdown('나의 포지션', _selectedPosition, _positions, _isEditing ? (val) => setState(() => _selectedPosition = val) : null),
              const SizedBox(height: 16),
              _buildDropdown('나의 능력치', _selectedAbility, _abilities, _isEditing ? (val) => setState(() => _selectedAbility = val) : null),
              const SizedBox(height: 16),
              if (_isEditing) ...[
                  TextFormField(
                  controller: _introController,
                  decoration: const InputDecoration(labelText: '내 프로필 문구', border: OutlineInputBorder()),
                   maxLines: 3,
                ),
                const SizedBox(height: 16),
                if (widget.user['job'] == '개발자')
                  TextFormField(
                    controller: _githubController,
                    decoration: const InputDecoration(labelText: '나의 외부 링크', border: OutlineInputBorder()),
                  ),
              ] else ...[
                 _buildDisplayField('내 프로필 문구', widget.user['introduction'] ?? '-'),
                 const SizedBox(height: 16),
                 _buildDisplayField('나의 외부 링크', widget.user['github'] ?? '-'),
              ],
              const SizedBox(height: 32),
              _buildSwitchTile('채팅을 받습니다', _receiveChats, _isEditing ? (val) => setState(() => _receiveChats = val) : null),
              const SizedBox(height: 8),
              _buildSwitchTile('내 프로필을 노출합니다', _showProfile, _isEditing ? (val) => setState(() => _showProfile = val) : null),
            ],
          ),
        ),
      ),
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

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?>? onChanged) {
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

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool>? onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
