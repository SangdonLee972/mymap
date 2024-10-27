// PokerRoomDetailPage에서 CashGamesTab 구현

import 'package:flutter/material.dart';
import 'package:pokerapp/models/CashGame.dart';
import 'package:pokerapp/service/PokerRoomService.dart';

class CashGamesTab extends StatelessWidget {
  final String roomId;
  final PokerRoomService _service = PokerRoomService();

  CashGamesTab({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CashGame>>(
      stream: _service.getCashGames(roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("현재 캐쉬게임이 없습니다."));
        } else {
          final cashGames = snapshot.data!;
          return ListView.builder(
            itemCount: cashGames.length,
            itemBuilder: (context, index) {
              final game = cashGames[index];
              return ListTile(
                title: Text(game.gameType),
                subtitle: Text("테이블 ${game.tableNumber}, 블라인드 ${game.blinds}"),
                trailing: Text("플레이어 수: ${game.players}"),
              );
            },
          );
        }
      },
    );
  }
}
