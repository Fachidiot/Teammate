import 'package:flutter/material.dart';
import 'package:teammate/RegisterDetailPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdateController = TextEditingController();

  String? _selectedGender;
  final List<String> _genders = ['남성', '여성'];

  // 직군 선택 변수 삭제됨

  bool _isPasswordVisible = false;

  void _nextClicked() {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'birthdate': _birthdateController.text,
        'gender': _selectedGender,
        'job': '미설정', // 기본값 처리 (나중에 프로필에서 수정 가능)
      };
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterDetailPage(userData: userData)));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _birthdateController.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('JOIN US', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("기본 정보 입력", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 40),

                  _buildMinimalInput(_emailController, "이메일", Icons.email_outlined),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "비밀번호",
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.black, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey, size: 20),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                    ),
                    validator: (v) => v!.isEmpty ? '비밀번호를 입력해주세요' : null,
                  ),
                  const SizedBox(height: 24),

                  _buildMinimalInput(_nameController, "이름", Icons.person_outline),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _birthdateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: const InputDecoration(
                      labelText: "생년월일",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black, size: 20),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                    ),
                    validator: (v) => v!.isEmpty ? '생년월일을 선택해주세요' : null,
                  ),
                  const SizedBox(height: 24),

                  // 직군 선택 삭제됨, 성별만 남김
                  _buildDropdown(_selectedGender, _genders, "성별", (v) => setState(() => _selectedGender = v)),

                  const SizedBox(height: 50),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextClicked,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: const Text('다음 단계', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalInput(TextEditingController c, String label, IconData icon) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.black, size: 20),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
      ),
      validator: (v) => v!.isEmpty ? '$label을 입력해주세요' : null,
    );
  }

  Widget _buildDropdown(String? val, List<String> items, String hint, Function(String?) changed) {
    return DropdownButtonFormField<String>(
      value: val,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: changed,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
      ),
      validator: (v) => v == null ? '선택' : null,
    );
  }
}