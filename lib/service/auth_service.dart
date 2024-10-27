import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pokerapp/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokerapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // 싱글톤 인스턴스를 제공하는 static 변수
  static final AuthService instance = AuthService._internal();

  // 내부 생성자
  AuthService._internal();

  // Firebase Auth 인스턴스
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();
  CustomUser? _currentCustomUser;

  // 현재 사용자 정보 접근 getter
  CustomUser? get currentUser => _currentCustomUser;


  // Firebase User 정보를 CustomUser로 변환하는 메서드
  Future<CustomUser?> _fetchFromFirebaseUser(auth.User firebaseUser) async {
    var customUser = await _userRepository.fetchUserFromFirestore(firebaseUser.uid);
    return customUser;
  }

    // Firebase User를 기반으로 CustomUser를 설정하는 메서드
  Future<void> login(auth.User firebaseUser) async {
    // 추후업데이트 예정사항 : if문을통해 캐시가 있으면 캐시를 받아내고 만약에 없다면 아래처럼서버로 불러내는형식
        var customUser = await _userRepository.fetchUserFromFirestore(firebaseUser.uid);

    _currentCustomUser =customUser;
  }


  // 이메일과 비밀번호로 로그인
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        _currentCustomUser = await _fetchFromFirebaseUser(firebaseUser);
        return null; // 성공 시 null 반환
      }
      return '로그인에 실패했습니다.';
    } on auth.FirebaseAuthException catch (e) {
      return _handleFirebaseAuthError(e);
    }
  }
  // 초기 로그인 상태를 확인하고 로그인 상태를 반환
  Future<bool> checkInitialLoginState() async {
    final auth.User? user = _auth.currentUser;
    if (user != null) {
      await login(user); // 로그인 상태 설정
      return true;
    } else {
      await signOut(); // 로그아웃 상태 설정
      return false;
    }
  }



  // 회원가입 메서드
  Future<String?> registerWithEmail(
    String email,
    String password, {
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        CustomUser customUser = CustomUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: name,
          profileImageUrl: '',
          phoneNumber: phoneNumber,
          role: 'user',
        );

        await _userRepository.saveUserToFirestore(customUser);
        _currentCustomUser = customUser; // 회원가입 성공 시 현재 사용자로 설정
        return null; // 성공 시 null 반환
      }
      return '회원가입에 실패했습니다.';
    } on auth.FirebaseAuthException catch (e) {
      return _handleFirebaseAuthError(e);
    }
  }

  // Firebase 인증 에러 처리 메서드
  String _handleFirebaseAuthError(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '유효한 이메일을 입력하세요.';
      case 'user-not-found':
        return '존재하지 않는 사용자입니다.';
      case 'wrong-password':
        return '비밀번호가 올바르지 않습니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'weak-password':
        return '비밀번호는 6자 이상이어야 합니다.';
      case 'invalid-credential':
        return '올바르지 않은 이메일 또는 비밀번호 입니다.';
      default:
        return '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }


  // 로그아웃 메서드
  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _currentCustomUser = null;
  }
}
