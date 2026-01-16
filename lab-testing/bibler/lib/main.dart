import 'package:flutter/material.dart';
import 'package:bibler/screens/wrapper.dart';
import 'package:bibler/screens/bibler/create_community.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumBarunGothic',
      ),
      routes: {
        '/': (context) => Wrapper(),
        '/create_community': (context) => CreateCommunityScreen(),
      },
      initialRoute: '/',
    );
  }
}