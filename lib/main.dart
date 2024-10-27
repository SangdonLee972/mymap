import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';
import 'package:pokerapp/Page/LoginPage.dart';
import 'package:pokerapp/Screen/MainScreen.dart';
import 'package:pokerapp/service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  KakaoSdk.init(
    nativeAppKey: 'b800c0c8311fbcd04ce803dadd389872',
    javaScriptAppKey: '6b5d8f0bbe6c73b217040dda64efcd46',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.checkInitialLoginState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          bool isLogined = snapshot.data ?? false;
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: isLogined ? MainScreen() : LoginPage(),
          );
        }
      },
    );
  }
}
