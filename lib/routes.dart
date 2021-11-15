import 'package:aba_analysis_local/screens/home/home_screen.dart';
import 'package:aba_analysis_local/screens/authenticate/find_password_screen.dart';
import 'package:aba_analysis_local/screens/authenticate/register_screen.dart';
import 'package:aba_analysis_local/screens/authenticate/sign_in_screen.dart';
import 'package:aba_analysis_local/wrapper.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  FindPasswordScreen.routeName: (context) => FindPasswordScreen(),
};
