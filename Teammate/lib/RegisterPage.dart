import 'package:flutter/material.dart';
import 'package:teammate/RegisterDetailPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _departmentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _nextPageClicked() {
    if (_formKey.currentState!.validate()) {
       if (!_isProfileShareAgreed || !_isPrivacyAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('필수 동의 항목에 체크해주세요.')),
        );
        return;
      }

      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'birthdate': _dateController.text,
        'gender': _selectedGender,
        'job': _selectedJobs,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterDetailPage(userData: userData),
        ),
      );
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("이름*"),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                const Text("메일 주소*"),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return '유효한 이메일 주소를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text("비밀번호*"),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text("비밀번호 확인*"),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 다시 입력해주세요.';
                    }
                    if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                const Text("메일 인증*"),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    labelText: "6자리 코드",
                    border: const OutlineInputBorder(),
                    suffixIcon: TextButton(
                      onPressed: () {},
                      child: const Text("인증"),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '인증 코드를 입력해주세요.';
                    }
                    return null;
                  },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '생년월일을 선택해주세요.';
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null) {
                                return '성별을 선택해주세요.';
                              }
                              return null;
                            },
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
                  validator: (value) {
                    if (value == null) {
                      return '직군을 선택해주세요.';
                    }
                    return null;
                  },
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
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 24),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _nextPageClicked,
                    child: const Text("다음"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
