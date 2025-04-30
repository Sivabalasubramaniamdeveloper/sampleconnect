import 'dart:ui';
import 'package:flutter/material.dart';

class KConstantColors {
  static const Color bgColor = Color(0xFF00A550);
  static const Color secondaryColor = Color(0xFF1DB954);
  static const Color balanceColor = Color(0xFFFF914D);
  static const Color primaryColor = Color(0xFF33006F);
  // static const Color primaryColor = Color(0xFF1DB954);
  static const Color error = Color(0xFFFF5963);
  static const Color secondaryBackground = Color(0xfff5f5f5);
  static const Color bgColorFaint = Color(0xFF2A2A2A);
  static const Color paleOrange = Color(0xFFFF9148);
  static const Color fadeOrange = Color(0xFFE3963E);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color yellowColor = Colors.yellow;
  static const Color orangeolor = Colors.orange;
  static const LinearGradient bottomBoxWithPrimaryColor = LinearGradient(
    colors: [primaryColor, primaryColor],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  static const LinearGradient BottomNavBar = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [KConstantColors.secondaryColor, KConstantColors.primaryColor],
  );
  static const Color goldcolor = Color(0xFFffd700);
  static  Color greyColor = Colors.grey.shade200;
  static  Color greyColorShade800 = Colors.grey.shade800;
  static const Color labelColor = Colors.black45;
  static const Color black54 = Colors.black54;
  static const Color hinttextColor = Color(0xff677681);
  static const Color faintWhiteColor = Colors.white70;
  static const Color loginColor = Color(0xFF3B2C7A);

  static const Color red = Colors.red;
  static const Color amber = Colors.amber;
  static const Color green = Colors.green;
  static const Color white = Colors.white;
  static const Color purpleAccent = Colors.purpleAccent;
  static const Color blue = Colors.blue;
  static const Color cyan = Colors.cyan;
  static const Color deepPurple = Colors.deepPurple;
}
