import 'package:flutter/material.dart';

import 'package:bibler/screens/kakao_login/kakao_login_screen.dart';
import 'package:bibler/screens/google_map/google_map_sample.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '457951f09b39d2b07b13eac04d093d67'); // 카카오 로그인 설정
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KakaoLoginScreen()),
                );
              },
              child: const Text('Kakao'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoogleMapSample()),
                );
              },
              child: const Text('Google'),
            ),
          ],
        ),
      ),
    );
  }
}
