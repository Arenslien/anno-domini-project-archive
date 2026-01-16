import 'package:aba_analysis/components/authenticate/auth_title_card.dart';
import 'package:aba_analysis/components/authenticate/register_screen/body.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Body(),
    );
  }
}
