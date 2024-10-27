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
      id: '',
      name: 'New Poker Room',
      location: 'Las Vegas, NV',
      logoUrl: 'https://example.com/logo.png',
      tables: 20,
      distance: 500.0,
      tournamentImage: 'https://example.com/tournament.png',
      supportsCashGames: false,
      hasEvents: true,
      hasTournaments: true,
    );

    await _pokerRoomService.addPokerRoom(pokerRoom);
    setState(() {
      _futurePokerRooms = _pokerRoomService.getPokerRooms();
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
            onPressed: _createPokerRoom,
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
              return _buildPokerRoomCard(room, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildPokerRoomCard(PokerRoom room, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PokerRoomDetailPage(room: room)),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 파란색 바
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                color: Colors.blue.shade900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Live info + Wait List Registration",
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                    ),
                    Icon(Icons.announcement, color: Colors.white, size: screenWidth * 0.04),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  // 포커룸 로고 이미지
                  CircleAvatar(
                    backgroundImage: NetworkImage(room.logoUrl),
                    radius: screenWidth * 0.07,
                  ),
                  SizedBox(width: 12),
                  // 포커룸 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          room.location,
                          style: TextStyle(color: Colors.grey.shade700, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                  ),
                  // 거리 정보
                  Text(
                    '${room.distance.toStringAsFixed(2)} km',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: screenWidth * 0.03),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Divider(color: Colors.grey.shade400),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn('Tables', '${room.tables}', screenWidth),
                  _buildConditionalIcon(room.supportsCashGames, 'Cash', Icons.attach_money, screenWidth),
                  _buildConditionalIcon(room.hasTournaments, 'Tourneys', Icons.emoji_events, screenWidth),
                  _buildConditionalIcon(room.hasEvents, 'Events', Icons.event, screenWidth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, dynamic value, double screenWidth, {bool isFaded = false}) {
    final textColor = isFaded ? Colors.grey : Colors.black;
    final iconColor = isFaded ? Colors.grey : Colors.blueAccent;

    return Column(
      children: [
        value is IconData
            ? Icon(value, size: screenWidth * 0.06, color: iconColor)
            : Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                  color: textColor,
                ),
              ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isFaded ? Colors.grey : Colors.grey.shade600,
            fontSize: screenWidth * 0.03,
          ),
        ),
      ],
    );
  }

  Widget _buildConditionalIcon(bool isVisible, String label, IconData icon, double screenWidth) {
    return _buildInfoColumn(
      label,
      icon,
      screenWidth,
      isFaded: !isVisible, // false이면 회색, true이면 선명하게
    );
  }
}
