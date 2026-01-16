import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;
  
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getProportionateScreenHeight(double ratio) {
  double screenHeight = SizeConfig.screenHeight;
  return ratio * screenHeight;
}

double getProportionateScreenWidth(double ratio) {
  double screenWidth = SizeConfig.screenWidth;
  return ratio * screenWidth;
}