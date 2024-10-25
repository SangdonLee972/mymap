import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CustomUser {
  final String uid;
  final String email;
  final String displayName;
  final String profileImageUrl;
  final String phoneNumber;
  final String role;

  CustomUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.profileImageUrl,
    required this.phoneNumber,
    required this.role,
  });

  // Firestore 문서에서 CustomUser로 변환
  factory CustomUser.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CustomUser(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      role: data['role'] ?? 'user',
    );
  }

  // Firebase User에서 CustomUser로 변환
  factory CustomUser.fromFirebaseUser(User firebaseUser) {
    return CustomUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      profileImageUrl: firebaseUser.photoURL ?? '',
      phoneNumber: firebaseUser.phoneNumber ?? '',
      role: 'user',
    );
  }

  // Firestore에 저장할 데이터를 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}
