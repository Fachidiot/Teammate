import 'package:flutter/material.dart';
// import '../InitPage';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  // 예시 데이터 및 상태 변수
  String? _selectedPosition;
  final List<String> _positions = ['개발자', '디자이너', '기획자'];
  String? _selectedAbility;
  final List<String> _abilities = ['상', '중', '하'];
  bool _receiveChats = true;
  bool _showProfile = true;

  // void logoutClicked() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const InitPage()),
  //   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 프로필 이미지 및 이름 섹션
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.image_outlined, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'User name',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            // TODO: 이름 수정 기능 구현
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 설정 목록 섹션
            _buildDropdown('나의 포지션', _selectedPosition, _positions, (val) {
              setState(() => _selectedPosition = val);
            }),
            const SizedBox(height: 16),
            _buildDropdown('나의 능력치', _selectedAbility, _abilities, (val) {
              setState(() => _selectedAbility = val);
            }),
            const SizedBox(height: 16),
            _buildTextButton('내 프로필 문구 수정', hasIcon: true),
            const SizedBox(height: 16),
            _buildTextButton('나의 외부링크 수정'),
            const SizedBox(height: 32),

            // 토글 스위치 섹션
            _buildSwitchTile('채팅을 받습니다', _receiveChats, (val) {
              setState(() => _receiveChats = val);
            }),
            const SizedBox(height: 8),
            _buildSwitchTile('내 프로필을 노출합니다', _showProfile, (val) {
              setState(() => _showProfile = val);
            }),
          ],
        ),
      ),
    );
  }

  // 중복 UI를 위한 헬퍼 위젯
  Widget _buildDropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
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
      ),
    );
  }

  Widget _buildTextButton(String text, {bool hasIcon = false}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        // TODO: 각 버튼 기능 구현
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.black)),
          if (hasIcon) const Icon(Icons.edit_outlined, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
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
