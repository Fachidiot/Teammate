import 'package:flutter/material.dart';
import 'package:teammate/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['남', '여'];
  String? _selectedJobs;
  final List<String> _jobs = ['개발자', '디자이너', '기획자']; // 예시 직군 목록

  bool _isProfileShareAgreed = false; // 프로필 공유 동의
  bool _isPrivacyAgreed = false; // 제3자 정보제공 동의
  bool _isMarketingAgreed = false;

  bool _showRequiredError = false; // 필드 관련 오류 표시 여부
  bool _privacyRequiredError = false; // 동의 관련 오류 표시 여부

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _verificationCodeController.dispose();
    _departmentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _registerClicked() {
    setState(() {
      // 모든 필수 필드가 채워졌는지 확인
      final bool areFieldsFilled =
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _verificationCodeController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          _selectedGender != null &&
          _selectedJobs != null;

      // 모든 필수 동의가 체크되었는지 확인
      final bool arePrivacyOptionsAgreed =
          _isProfileShareAgreed && _isPrivacyAgreed;

      // 오류 상태 업데이트 (조건이 충족되지 않으면 true)
      _showRequiredError = !areFieldsFilled;
      _privacyRequiredError = !arePrivacyOptionsAgreed;

      // 모든 조건이 충족되면 회원가입 처리 및 페이지 이동
      if (areFieldsFilled && arePrivacyOptionsAgreed) {
        // TODO: 회원가입 로직 처리
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  void loginClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(
          ' ',
        )[0]; // YYYY-MM-DD 형식
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("이름*"),
              const SizedBox(height: 8.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8.0),
              const Text("메일 주소*"),
              const SizedBox(height: 8.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8.0),
              const Text("메일 인증*"),
              const SizedBox(height: 8.0),
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: "6자리 코드",
                  border: const OutlineInputBorder(),
                  suffixIcon: TextButton(
                    onPressed: () {},
                    child: const Text("인증"),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("생년월일*"),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: const InputDecoration(
                            // labelText: "YYYY-MM-DD",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("성별*"),
                        const SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          items: _genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                            // labelText: "성별",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text("직군*"),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedJobs,
                items: _jobs.map((String school) {
                  return DropdownMenuItem<String>(
                    value: school,
                    child: Text(school),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedJobs = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "직군 선택",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    Expanded(child: Text('프로필 공유를 허용하시겠습니까?(필수)')),
                    Checkbox(
                      value: _isProfileShareAgreed,
                      onChanged: (bool? value) {
                        setState(() {
                          _isProfileShareAgreed = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(child: Text('제3자의 개인정보 이용에 동의합니다(필수)')),
                  Checkbox(
                    value: _isPrivacyAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPrivacyAgreed = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('홍보성 메일 수신에 동의합니다(선택)')),
                  Checkbox(
                    value: _isMarketingAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        _isMarketingAgreed = value!;
                      });
                    },
                  ),
                ],
              ),
              if (_showRequiredError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '*는 필수 입력 항목입니다.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_privacyRequiredError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '필수 동의 항목에 체크해주세요.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 24),
                height: 50,
                child: ElevatedButton(
                  onPressed: _registerClicked,
                  child: const Text("회원가입"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
