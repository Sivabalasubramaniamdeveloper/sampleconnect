import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextStyle.dart';
import '../CommonFunctions.dart';

showErrorToast(String message, {Toast toastLength = Toast.LENGTH_LONG}) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 3,
    fontSize: 13.sp,
    toastLength: toastLength,
    textColor: Colors.white,
  );
}

showWarningToast(String message, {Toast toastLength = Toast.LENGTH_LONG}) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 3,
    fontSize: 13.sp,
    toastLength: toastLength,
    backgroundColor: KConstantColors.primaryColor,
    textColor: Colors.white,
  );
}

showSuccessToast(String message, {Toast toastLength = Toast.LENGTH_LONG}) {
  Fluttertoast.showToast(
    msg: capitalizeFirstLetter(message),
    timeInSecForIosWeb: 3,
    fontSize: 13.sp,
    gravity: ToastGravity.BOTTOM,
    toastLength: toastLength,
    textColor: KConstantColors.primaryColor,
  );
}

showToast(String message, {Toast toastLength = Toast.LENGTH_LONG}) {
  Fluttertoast.showToast(
    msg: message,
    webShowClose: true,
    fontSize: 13.sp,
    gravity: ToastGravity.TOP,
    toastLength: toastLength,
    backgroundColor: const Color(0xff444983),
    textColor: Colors.white,
  );
}

showSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style:
        TextStyleClass.textSize14Bold(),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
