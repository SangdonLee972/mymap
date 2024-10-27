import 'package:flutter/material.dart';
import 'package:pokerapp/Screen/MainScreen.dart';
import 'package:pokerapp/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;
  bool isRegisterMode = false;

  // Track error states for individual fields
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  bool _nameError = false;
  bool _phoneError = false;

  // Clear all input controllers
  void _clearControllers() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _nameController.clear();
    _phoneController.clear();
  }

  // Navigate to MainScreen on successful login
  void _navigateToMainPage() {
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
  }

  // Sign in with email and password
  Future<void> _signInWithEmail() async {
    setState(() {
      _errorMessage = null;
      _emailError = false;
      _passwordError = false;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = '이메일과 비밀번호를 모두 입력해주세요.';
        _emailError = _emailController.text.isEmpty;
        _passwordError = _passwordController.text.isEmpty;
      });
      return;
    }

    // Use the AuthService singleton instance
    String? error = await AuthService.instance.signInWithEmail(
      _emailController.text,
      _passwordController.text,
    );


    if (error == null) {
      _navigateToMainPage();
    } else {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  // Register a new user
  Future<void> _registerWithEmail() async {
    setState(() {
      _errorMessage = null;
      _emailError = false;
      _passwordError = false;
      _confirmPasswordError = false;
      _nameError = false;
      _phoneError = false;
    });

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      setState(() {
        _errorMessage = '모든 필드를 입력해주세요.';
        _emailError = _emailController.text.isEmpty;
        _passwordError = _passwordController.text.isEmpty;
        _confirmPasswordError = _confirmPasswordController.text.isEmpty;
        _nameError = _nameController.text.isEmpty;
        _phoneError = _phoneController.text.isEmpty;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = '비밀번호가 일치하지 않습니다.';
        _confirmPasswordError = true;
      });
      return;
    }

    // Use the AuthService singleton instance
    String? error = await AuthService.instance.registerWithEmail(
      _emailController.text,
      _passwordController.text,
      name: _nameController.text,
      phoneNumber: _phoneController.text,
    );

    if (error == null) {
      setState(() {
        isRegisterMode = false; // Switch to login mode after successful registration
        _clearControllers();
      });
    } else {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, bool isError) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('assets/logo.png', width: 120, height: 120),
                ),
                SizedBox(height: 30),

                if (isRegisterMode) ...[
                  TextField(
                    controller: _nameController,
                    decoration: _buildInputDecoration('이름', _nameError),
                    onTap: () {
                      setState(() => _nameError = false);
                    },
                  ),
                  SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailController,
                  decoration: _buildInputDecoration('이메일', _emailError),
                  onTap: () {
                    setState(() => _emailError = false);
                  },
                ),
                SizedBox(height: 16),

                if (isRegisterMode) ...[
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration('전화번호', _phoneError),
                    onTap: () {
                      setState(() => _phoneError = false);
                    },
                  ),
                  SizedBox(height: 16),
                ],

                TextField(
                  controller: _passwordController,
                  decoration: _buildInputDecoration('비밀번호', _passwordError),
                  obscureText: true,
                  onTap: () {
                    setState(() => _passwordError = false);
                  },
                ),
                SizedBox(height: 16),

                if (isRegisterMode) ...[
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: _buildInputDecoration('비밀번호 확인', _confirmPasswordError),
                    obscureText: true,
                    onTap: () {
                      setState(() => _confirmPasswordError = false);
                    },
                  ),
                  SizedBox(height: 24),
                ],

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                ElevatedButton(
                  onPressed: isRegisterMode ? _registerWithEmail : _signInWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isRegisterMode ? '회원가입' : '로그인',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 12),

                // Toggle between Register and Login modes
                if (!isRegisterMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '계정이 없으신가요? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isRegisterMode = true;
                            _clearControllers(); // Clear all fields when switching to register mode
                            _errorMessage = null;
                          });
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
                        ),
                        splashColor: Colors.blueAccent.withOpacity(0.3),
                        highlightColor: Colors.blueAccent.withOpacity(0.1),
                      ),
                    ],
                  ),

                if (isRegisterMode)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRegisterMode = false;
                        _clearControllers(); // Clear all fields when switching to login mode
                        _errorMessage = null;
                      });
                    },
                    child: Text(
                      '로그인 화면으로 돌아가기',
                      style: TextStyle(color: Colors.blueAccent),
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
