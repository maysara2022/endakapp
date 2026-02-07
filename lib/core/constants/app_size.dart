import 'package:flutter/material.dart';

class AppSize {
  static late MediaQueryData _mediaQueryData;

  static double screenWidth = 0;
  static double screenHeight = 0;

  static SizedBox box(double height,double width) {

    return SizedBox(height: screenHeight*height,width: screenWidth* width,);
  }


  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }
}