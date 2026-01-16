import 'package:flutter/material.dart';
import 'package:bibler/screens/authentication/login.dart';
import 'package:bibler/screens/bibler/bibler.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // 유저가 로그인 유지를 활성화한 경우 _user = true
    var _user = true;

    if(_user) {
      return BiblerScreen();
    } else {
      return LoginScreen();
    }
  }
}