import 'package:flutter/material.dart';

class MyTheme {


  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGray = Color.fromRGBO(239, 239, 239, 1);
  static const Color darkGray = Color.fromRGBO(112, 112, 112, 1);
  static const Color mediumGray = Color.fromRGBO(132, 132, 132, 1);
  static const Color grey_153 = Color.fromRGBO(153, 153, 153, 1);
  static const Color fontGrey = Color.fromRGBO(73, 73, 73, 1);
  static const Color textfieldGray = Color.fromRGBO(209, 209, 209, 1);

  static const Color black_34 = Color.fromRGBO(34, 34, 34, 1);
  static const Color black_85 = Color.fromRGBO(85, 85, 85, 1);
  static const Color grey_102 = Color.fromRGBO(102, 102, 102, 1);
  static const Color white_204 = Color.fromRGBO(204, 204, 204, 1);
  static const Color primaryColor = Color(0xff263f9b);
  static const Color secondaryColor = Color(0xff2b48b0);
  static const Color accentColor = Color(0xff21bdcf);
  static const Color secondaryAccentColor = Color(0xff0f2757);
  static const Color shadowColor = Color.fromRGBO(34, 34, 34, 0.1);
  static const Color offWhiteScaffoldColor = Color(0xfffdfdfd);
  static const Color whiteScaffoldColor = Color(0xffffffff);
  static const Color golden = Color(0xffFFD700);




  static final Map<int, Color> _colorMap = {
    50: primaryColor.withOpacity(0.1),
    100: primaryColor.withOpacity(.2),
    200: primaryColor.withOpacity(.3),
    300: primaryColor.withOpacity(.4),
    400: primaryColor.withOpacity(.5),
    500: primaryColor.withOpacity(.6),
    600: primaryColor.withOpacity(.7),
    700: primaryColor.withOpacity(.8),
    800: primaryColor.withOpacity(.9),
    900: primaryColor.withOpacity(1),
  };

  static MaterialColor get primarySwatch => MaterialColor(primaryColor.value, _colorMap);
}
