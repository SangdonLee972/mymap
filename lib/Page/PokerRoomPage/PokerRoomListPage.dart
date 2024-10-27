// pages/poker_room_list_page.dart

import 'package:flutter/material.dart';
import 'package:pokerapp/Page/PokerRoomPage/PokerRoomDetailPage.dart';
import 'package:pokerapp/models/PokerRoom.dart';
import 'package:pokerapp/service/PokerRoomService.dart';

class PokerRoomListPage extends StatefulWidget {
  @override
  _PokerRoomListPageState createState() => _PokerRoomListPageState();
}

class _PokerRoomListPageState extends State<PokerRoomListPage> {
  final PokerRoomService _pokerRoomService = PokerRoomService();
  late Future<List<PokerRoom>> _futurePokerRooms;

  @override
  void initState() {
    super.initState();
    _futurePokerRooms = _pokerRoomService.getPokerRooms();
  }

  Future<void> _createPokerRoom() async {
    final pokerRoom = PokerRoom(
      id: '', // Firestore에서 자동 생성
      name: 'New Poker Room',
      location: 'Las Vegas, NV',
      logoUrl: 'https://example.com/logo.png', // 샘플 이미지 URL
      tables: 20,
      distance: 500.0,
      tournamentImage: 'https://example.com/tournament.png', // 샘플 토너먼트 이미지 URL
    );

    await _pokerRoomService.addPokerRoom(pokerRoom);
    setState(() {
      _futurePokerRooms = _pokerRoomService.getPokerRooms(); // 새로운 포커룸 리스트 가져오기
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poker Rooms'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createPokerRoom, // 버튼 클릭 시 포커룸 생성
          ),
        ],
      ),
      body: FutureBuilder<List<PokerRoom>>(
        future: _futurePokerRooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No poker rooms found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];
              return ListTile(
                title: Text(room.name),
                subtitle: Text(room.location),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PokerRoomDetailPage(room: room)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
