import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokerapp/Page/PokerRoomPage/PokerRoomListPage.dart';
import 'package:pokerapp/models/user.dart';
import 'package:pokerapp/service/auth_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    CustomUser customUser = AuthService.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // 주요 서비스 섹션
            Text(
              '주요 서비스',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade900,
              ),
            ),
            SizedBox(height: 8),
            StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildServiceIcon(FontAwesomeIcons.gift, '선물하기', screenWidth, context, () => _giftAction(context)),
                _buildServiceIcon(FontAwesomeIcons.shoppingBag, '쇼핑', screenWidth, context, _shoppingAction),
                _buildServiceIcon(FontAwesomeIcons.bicycle, '자전거 대여', screenWidth, context, _rentBikeAction),
                _buildServiceIcon(FontAwesomeIcons.moneyBill, 'ATM 찾기', screenWidth, context, _findATMAction),
                _buildServiceIcon(FontAwesomeIcons.creditCard, '카드', screenWidth, context, _cardAction),
                _buildServiceIcon(FontAwesomeIcons.wallet, '계좌 조회', screenWidth, context, _checkAccountAction),
                _buildServiceIcon(FontAwesomeIcons.moneyCheck, '송금', screenWidth, context, _sendMoneyAction),
                _buildServiceIcon(FontAwesomeIcons.piggyBank, 'My자산', screenWidth, context, _myAssetsAction),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, double screenWidth, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: screenWidth * 0.044, color: Colors.blueAccent),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.025,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  // 버튼 클릭 시 실행할 개별 핸들러 함수들
  void _giftAction(BuildContext context) {
    print("선물하기 클릭됨");

       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokerRoomListPage()),
    );
    // 선물하기 기능 구현
  }

  void _shoppingAction() {
    print("쇼핑 클릭됨");
    // 쇼핑 기능 구현
  }

  void _rentBikeAction() {
    print("자전거 대여 클릭됨");
    // 자전거 대여 기능 구현
  }

  void _findATMAction() {
    print("ATM 찾기 클릭됨");
    // ATM 찾기 기능 구현
  }

  void _cardAction() {
    print("카드 클릭됨");
    // 카드 기능 구현
  }

  void _checkAccountAction() {
    print("계좌 조회 클릭됨");
    // 계좌 조회 기능 구현
  }

  void _sendMoneyAction() {
    print("송금 클릭됨");
    // 송금 기능 구현
  }

  void _myAssetsAction() {
    print("My자산 클릭됨");
    // My자산 기능 구현
  }
}
