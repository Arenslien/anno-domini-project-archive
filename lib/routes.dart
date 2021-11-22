import 'package:aba_analysis_local/screens/home/home_screen.dart';
import 'package:aba_analysis_local/splash_screen.dart';
import 'package:aba_analysis_local/wrapper.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
};
