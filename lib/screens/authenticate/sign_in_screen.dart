import 'package:aba_analysis/components/authenticate/sign_in_screen/body.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = '/sign_in';
  const SignInScreen({ Key? key }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Authentication 관련 property
  final AuthService _auth = AuthService();
  late String id;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Body(),
    );
  }
}







