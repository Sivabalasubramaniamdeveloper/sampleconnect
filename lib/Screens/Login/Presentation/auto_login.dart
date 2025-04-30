import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Components/CommonFunctions.dart';
import '../../../Components/CustomToast/CustomToast.dart';

class AutoLogin extends StatefulWidget {
  const AutoLogin({super.key});

  @override
  State<AutoLogin> createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkForAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("s"),
    );
  }

  Future<void> _checkForAutoLogin() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    final username = localDb.getString("username");
    final uuid = localDb.getString("uuid");

    Future.delayed(Duration.zero, () {
      if (username != null && uuid != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/chatList',
          (route) => false,
        );
        showSuccessToast(
            "${capitalizeFirstLetter(username)} is Successfully Login");
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/gmailAuth',
          (route) => false,
        );
      }
    });
  }
}
