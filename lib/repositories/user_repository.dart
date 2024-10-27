import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokerapp/models/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 사용자 정보를 Firestore에 저장
  Future<void> saveUserToFirestore(CustomUser customUser) async {
    await _firestore.collection('users').doc(customUser.uid).set(customUser.toFirestore());
  }

  // Firestore에서 사용자 정보를 불러옴
  Future<CustomUser?> fetchUserFromFirestore(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return CustomUser.fromFirestore(userDoc.data() as Map<String, dynamic>, userDoc.id);
    }
    return null;
  }
}
