// services/poker_room_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokerapp/models/CashGame.dart';
import 'package:pokerapp/models/PokerRoom.dart';

class PokerRoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 포커룸 목록을 가져오는 메서드
  Future<List<PokerRoom>> getPokerRooms() async {
    final snapshot = await _firestore.collection('PokerRooms').get();
    return snapshot.docs
        .map((doc) => PokerRoom.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // 포커룸 상세 정보 가져오기
  Future<PokerRoom> getPokerRoom(String roomId) async {
    final doc = await _firestore.collection('PokerRooms').doc(roomId).get();
    return PokerRoom.fromFirestore(doc.data()!, doc.id);
  }

  // 새로운 포커룸 추가
  Future<void> addPokerRoom(PokerRoom pokerRoom) async {
    await _firestore.collection('PokerRooms').add(pokerRoom.toFirestore());
  }

  // 특정 포커룸의 실시간 캐쉬게임 리스트 가져오기
  Stream<List<CashGame>> getCashGames(String roomId) {
    return _firestore
        .collection('PokerRooms')
        .doc(roomId)
        .collection('CashGames')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CashGame.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // 캐쉬게임 상태를 업데이트하는 메서드 (딜러가 직접 수기로 입력)
  Future<void> updateCashGame(String roomId, CashGame cashGame) async {
    await _firestore
        .collection('PokerRooms')
        .doc(roomId)
        .collection('CashGames')
        .doc(cashGame.id)
        .set(cashGame.toFirestore());
  }

  // 새로운 캐쉬게임 추가
  Future<void> addCashGame(String roomId, CashGame cashGame) async {
    await _firestore
        .collection('PokerRooms')
        .doc(roomId)
        .collection('CashGames')
        .add(cashGame.toFirestore());
  }
}
