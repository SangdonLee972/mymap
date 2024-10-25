import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; // 올바른 패키지 임포트

class MainScreen extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(), // 메인 화면
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
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(), // 네비게이션에 따른 화면 리스트
      items: _navBarsItems(), // 네비게이션 아이템 설정
      backgroundColor: Colors.white, // 바텀 네비게이션 바 배경색
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
    
      navBarStyle: NavBarStyle.style6, // 네비게이션 바 스타일 설정
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 화면 크기를 기준으로 레이아웃 조정
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '메인 페이지',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: width * 0.05, // 해상도에 맞춘 폰트 크기
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 줄에 4개씩 배치
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1, // 정사각형 버튼
          ),
          itemCount: 8, // 8개의 버튼
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                // 각 버튼 클릭 시 기능 정의
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200], // 미니멀한 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // 둥근 모서리
                ),
                padding: EdgeInsets.all(20),
                elevation: 3, // 살짝의 그림자 효과
              ),
              child: Center(
                child: Text(
                  '버튼 ${index + 1}', // 버튼 텍스트
                  style: TextStyle(
                    fontSize: width * 0.045, // 해상도에 맞춘 텍스트 크기
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}