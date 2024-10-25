import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokerapp/Page/MainScreen.dart';
import 'package:pokerapp/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  // 로그인 성공 시 MainPage로 이동
  void _navigateToMainPage(User? user) {
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  // 로그인 실패 시 팝업창 띄우기
  void _showLoginFailedDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그인 실패'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업창 닫기
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 표시
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/logo.png', width: 150, height: 150), // 로고 이미지
            ),
            SizedBox(height: 40),
            // Kakao 로그인 버튼
            ElevatedButton(
              onPressed: () async {
          try {
                  User? user = await _authService.signInWithKakao();
                  if (user != null) {
                    print('KaKao 로그인 성공: ${user.displayName}');
                    // 로그인이 성공하면 다음 페이지로 이동 등 처리
                    _navigateToMainPage(user);
                  } else {
                    _showLoginFailedDialog('로그인에 실패했습니다.');
                  }
                } catch (e) {
                  print('Google 로그인 오류: $e');
                  _showLoginFailedDialog('로그인 오류: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFEE500),
              ),
              child: Text('카카오톡으로 로그인', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 10),
            // Facebook 로그인 버튼
            ElevatedButton(
              onPressed: () async {
                // User? user = await _signInWithFacebook();
                // _navigateToMainPage(user);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1877F2),
              ),
              child: Text('페이스북으로 로그인', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            // Google 로그인 버튼
            ElevatedButton(
              onPressed: () async {
                try {
                  User? user = await _authService.signInWithGoogle();
                  if (user != null) {
                    print('Google 로그인 성공: ${user.displayName}');
                    // 로그인이 성공하면 다음 페이지로 이동 등 처리
                    _navigateToMainPage(user);
                  } else {
                    _showLoginFailedDialog('로그인에 실패했습니다.');
                  }
                } catch (e) {
                  print('Google 로그인 오류: $e');
                  _showLoginFailedDialog('로그인 오류: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // 텍스트 및 아이콘 색상
                minimumSize: Size(200, 50), // 버튼 크기
                side: BorderSide(color: Colors.grey), // 테두리
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/LoginPage/google_logo.png', // 구글 로고 이미지
                    height: 24.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '구글로 로그인',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
