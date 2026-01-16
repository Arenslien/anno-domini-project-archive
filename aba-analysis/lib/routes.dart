import 'package:aba_analysis/screens/home/home_screen.dart';
import 'package:aba_analysis/screens/authenticate/register_screen.dart';
import 'package:aba_analysis/screens/authenticate/sign_in_screen.dart';
import 'package:aba_analysis/screens/setting/approve_registration_screen.dart';
import 'package:aba_analysis/screens/setting/edit_info_screen.dart';
import 'package:aba_analysis/screens/setting/user_management_screen.dart';
import 'package:aba_analysis/splash_screen.dart';
import 'package:aba_analysis/wrapper.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  EditInfoScreen.routeName: (context) => EditInfoScreen(),
  ApproveRegistrationScreen.routeName: (context) => ApproveRegistrationScreen(),
  UserManagementScreen.routeName: (context) => UserManagementScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
};
