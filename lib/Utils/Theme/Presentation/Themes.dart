import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/ColorConstants.dart';
import '../../Constants/TextStyle.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      disabledColor: Colors.black38,
      primaryColor: Color(0xFFEFF2FF),
      cardColor:Colors.white,
      // secondaryHeaderColor: Colors.black87,
      hintColor: KConstantColors.primaryColor,
      scaffoldBackgroundColor:Color(0xfff5f5f5),
      appBarTheme: AppBarTheme(
        color: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 20.0,
        ),
        iconTheme:
            IconThemeData(color: KConstantColors.primaryColor, size: 30.sp),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyleClass.textSize14(
          color: KConstantColors.primaryColor,
        ),
      )
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
      //     .copyWith(background: Colors.white),
      );
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1E1E1E),
    cardColor: Colors.black,
    // secondaryHeaderColor: Colors.white,
    hintColor: KConstantColors.primaryColor,
    disabledColor: Colors.black38,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 20.0,
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFFFFFFF),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 16.sp,
        fontFamily: "OpenSans",
      ),
    ),
    // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
    //     .copyWith(background: Colors.white),
  );
}
