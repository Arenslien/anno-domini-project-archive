import 'package:aba_analysis/components/setting/setting_screen/body.dart';
import 'package:aba_analysis/constants.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static String routeName = '/auth';
  const SettingScreen({ Key? key }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreenColor,
      appBar: AppBar(
        backgroundColor: mainGreenColor,
        title: Text('내 정보', style: TextStyle(color: Colors.white),),
        centerTitle: false,
      ),
      body: Body(),
    );
  }
}
