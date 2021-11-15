import 'package:aba_analysis_local/size_config.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/screens/home/home_screen.dart';

class Wrapper extends StatefulWidget {
  static String routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //SizeConfig를 사용하기 위해서 초기화
    SizeConfig().init(context);

    // return 홈스크린 or 인증스크린
    return HomeScreen();
  }
}
