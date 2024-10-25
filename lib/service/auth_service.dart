import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';
import 'package:pokerapp/models/user.dart'; // Custom User class
import 'package:pokerapp/repositories/user_repository.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRepository _userRepository = UserRepository();

  // Kakao 로그인
  Future<auth.User?> signInWithKakao() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount(); // 카카오 로그인
      var provider = auth.OAuthProvider('oidc.kakao'); // 제공업체 id
      
      var credential = provider.credential(
        idToken: token.idToken, // OpenID Connect를 사용할 경우에 idToken 사용 가능
        accessToken: token.accessToken,
      );
      
      auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print('카카오계정으로 로그인 실패: $error');
      return null;
    }
  }

  // 구글 로그인 및 Firestore에 사용자 정보 저장
  Future<auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // 로그인 취소

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
      final auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        CustomUser customUser = CustomUser.fromFirebaseUser(firebaseUser);
        await _userRepository.saveUserToFirestore(customUser);
      }

      return firebaseUser;
    } catch (e) {
      print('Google 로그인 오류: $e');
      return null;
    }
  }
}
