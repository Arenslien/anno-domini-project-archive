import 'package:aba_analysis/components/authenticate/find_password_screen.dart/body.dart';
import 'package:flutter/material.dart';

class FindPasswordScreen extends StatefulWidget {
  static String routeName = '/find_password';
  const FindPasswordScreen({ Key? key }) : super(key: key);

  @override
  _FindPasswordScreenState createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}