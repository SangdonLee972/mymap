import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pokerapp/Page/HomePage.dart';
import 'package:pokerapp/Page/LoginPage.dart';
import 'package:pokerapp/models/user.dart';
import 'package:pokerapp/service/auth_service.dart'; // CustomUser 클래스 임포트

class MainScreen extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreens() {
    return [
      HomePage(), // 메인 화면
      Center(child: Text('포커 위치 찾기')),
      Center(child: Text('커뮤니티')),
      Center(child: Text('내 정보')),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("홈"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.location_on),
        title: ("포커 위치 찾기"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.forum),
        title: ("커뮤니티"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("내 정보"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메인 페이지"),
                automaticallyImplyLeading: false, // 뒤로 가기 버튼을 비활성화

        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService.instance.signOut(); // 로그아웃 처리
                  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // 이동할 페이지 지정
    );
                },
          ),
        ],
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}

