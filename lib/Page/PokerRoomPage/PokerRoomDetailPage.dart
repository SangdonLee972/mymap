import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/PokerRoom.dart';

class PokerRoomDetailPage extends StatelessWidget {
  final PokerRoom room;

  PokerRoomDetailPage({required this.room});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(room.name),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: '토너먼트'),
              Tab(text: '캐쉬게임'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildTournamentTab(),
            _buildCashGamesTab(room.id),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Center(child: Text("포커룸에 대한 간단한 개요를 보여줍니다."));
  }

  Widget _buildTournamentTab() {
    return Center(
      child: room.tournamentImage != null
          ? Image.network(room.tournamentImage!)
          : Text("토너먼트 정보가 없습니다."),
    );
  }

  Widget _buildCashGamesTab(String roomId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('PokerRooms')
          .doc(roomId)
          .collection('CashGames')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return Center(child: Text("현재 캐쉬게임이 없습니다."));

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var data = doc.data();
            return ListTile(
              title: Text(data['gameType']),
              subtitle: Text("테이블 ${data['tableNumber']}, 블라인드 ${data['blinds']}"),
              trailing: Text("플레이어 수: ${data['players']}"),
            );
          }).toList(),
        );
      },
    );
  }
}
