import 'dart:async';

import 'package:flutter/material.dart';
import 'package:show_me_the_graph/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation, Widget child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.linear);
          return FadeTransition(opacity: animation, child: child);
        },
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation) {
          return HomeScreen();
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo here
            Image.asset('assets/images/logo.jpeg', height: 230.0),
          ],
        )
      )
    );
  }
}
