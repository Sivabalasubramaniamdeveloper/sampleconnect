import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Firebase/controllers/firebase_auth.dart';
import 'ColorConstants.dart';
import 'TextConstants.dart';
import 'TextStyle.dart';

class CustomWidgets {
  showLogoutDialog(BuildContext context, {bool isValidRole = true}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          TextConstants.logout,
          style:
              TextStyleClass.textSize17Bold(color: Theme.of(context).hintColor),
        ),
        content: Text(
          TextConstants.logoutMsg,
          style: TextStyleClass.textSize15(color: Theme.of(context).hintColor),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(TextConstants.cancel,
                style: TextStyleClass.textSize14Bold(
                    color: Theme.of(context).hintColor)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => FirebaseAuthentication().signOut(context),
            child: Text(TextConstants.logout,
                style:
                    TextStyleClass.textSize14Bold(color: KConstantColors.red)),
          ),
        ],
      ),
    );
  }
  Widget getGreetingWidget(BuildContext context) {
    final hour = DateTime.now().hour;

    String greetingText;
    IconData iconData;
    Color iconColor;

    if (hour >= 5 && hour < 12) {
      greetingText = TextConstants.morning_text;
      iconData = Icons.sunny;
      iconColor = KConstantColors.yellowColor;
    } else if (hour >= 12 && hour < 17) {
      greetingText = TextConstants.afternoon_text;
      iconData = Icons.wb_sunny;
      iconColor = KConstantColors.orangeolor;
    } else {
      greetingText = TextConstants.evening_text;
      iconData = Icons.nights_stay;
      iconColor = KConstantColors.blackColor;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          greetingText,
          style: TextStyle(
              color: Theme.of(context).hintColor, fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 5.w), // Add spacing between text and icon
        Icon(
          iconData,
          color: iconColor,
        ),
      ],
    );
  }
}
