// models/poker_room.dart

class PokerRoom {
  final String id;
  final String name;
  final String location;
  final String logoUrl;
  final int tables;
  final double distance;
  final String? tournamentImage; // 관리자 권한으로 업로드된 토너먼트 이미지

  PokerRoom({
    required this.id,
    required this.name,
    required this.location,
    required this.logoUrl,
    required this.tables,
    required this.distance,
    this.tournamentImage,
  });

  // Firestore에서 데이터를 가져와 PokerRoom 객체로 변환하는 팩토리 메서드
  factory PokerRoom.fromFirestore(Map<String, dynamic> json, String id) {
    return PokerRoom(
      id: id,
      name: json['name'],
      location: json['location'],
      logoUrl: json['logoUrl'],
      tables: json['tables'],
      distance: json['distance'].toDouble(),
      tournamentImage: json['tournamentImage'],
    );
  }

  // Firestore에 저장할 수 있는 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'tables': tables,
      'distance': distance,
      'tournamentImage': tournamentImage,
    };
  }
}
