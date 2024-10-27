// models/cash_game.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CashGame {
  final String id;
  final String gameType;
  final int tableNumber;
  final int players;
  final String blinds;
  final String updatedBy;
  final DateTime updatedAt;

  CashGame({
    required this.id,
    required this.gameType,
    required this.tableNumber,
    required this.players,
    required this.blinds,
    required this.updatedBy,
    required this.updatedAt,
  });

  // Firestore에서 데이터를 가져와 CashGame 객체로 변환하는 팩토리 메서드
  factory CashGame.fromFirestore(Map<String, dynamic> json, String id) {
    return CashGame(
      id: id,
      gameType: json['gameType'],
      tableNumber: json['tableNumber'],
      players: json['players'],
      blinds: json['blinds'],
      updatedBy: json['updatedBy'],
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Firestore에 저장할 수 있는 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'gameType': gameType,
      'tableNumber': tableNumber,
      'players': players,
      'blinds': blinds,
      'updatedBy': updatedBy,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
