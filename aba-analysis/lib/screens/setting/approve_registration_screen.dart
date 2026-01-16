import 'package:aba_analysis/components/setting/approve_registration/body.dart';
import 'package:aba_analysis/constants.dart';
import 'package:flutter/material.dart';

class ApproveRegistrationScreen extends StatefulWidget {
  static String routeName = '/approve_registration';
  const ApproveRegistrationScreen({ Key? key }) : super(key: key);

  @override
  _ApproveRegistrationScreenState createState() => _ApproveRegistrationScreenState();
}

class _ApproveRegistrationScreenState extends State<ApproveRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreenColor,
      appBar: AppBar(
        backgroundColor: mainGreenColor,
        title: Text('회원가입 승인', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: Body(),
    );
  }
}
