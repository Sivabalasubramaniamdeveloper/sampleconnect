import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ColorConstants.dart';

class TextStyleClass {
  static TextStyle textStyle(
      {double? size = 16, Color? color, FontWeight? fontWeight}) {
    //GoogleFonts.poppins
    return TextStyle(
      fontSize: size!.sp,
      fontFamily: "Manrope",
      color: color ?? KConstantColors.blackColor,
      fontWeight: fontWeight,
    );
  }

//all font size

  static TextStyle textSize10({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 10.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize10Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 10.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize11({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 11.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize11Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 11.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize12({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 12.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize12Half({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 12.5.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize12HalfBold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 12.5.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize12Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 12.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize13({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 13.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize13Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 13.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize14({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 14.sp, color: color, fontWeight: FontWeight.w500);
  }

  static TextStyle textSize14Half({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 14.5.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize14Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 14.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize15({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 15.sp, color: color, fontWeight: FontWeight.w500);
  }

  static TextStyle textSize15Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 15.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize16({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 16.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize16Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 16.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize17({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 17.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize17Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 17.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize18({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 18.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize18Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 18.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize20({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 20.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize21({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 21.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize21Bold({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 21.sp, color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle textSize22({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 22.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize24({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 24.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize26({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 26.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize28({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 28.sp, color: color, fontWeight: fontWeight);
  }

  static TextStyle textSize30({Color? color, FontWeight? fontWeight}) {
    return textStyle(size: 30.sp, color: color, fontWeight: fontWeight);
  }

// Add more methods for different sizes if needed.
}
