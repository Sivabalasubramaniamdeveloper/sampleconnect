import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Components/CommonFunctions.dart';
import '../../../Components/CustomToast/CustomToast.dart';
import '../../../Firebase/controllers/firebase_auth.dart';
import '../../../Firebase/controllers/firebase_firestore.dart';
import '../../../Models/UserModel.dart';
import '../../../Utils/Constants/ImageConstants.dart';
import '../../../Utils/Constants/TextConstants.dart';
import '../../UserList/Presentation/user_list.dart';

class GmailAuthPage extends StatefulWidget {
  @override
  _GmailAuthPageState createState() => _GmailAuthPageState();
}

class _GmailAuthPageState extends State<GmailAuthPage> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.googleLogo, height: 80.h),
            SizedBox(height: 20.h),
            Text(
              TextConstants.signINGmail,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _isSigningIn
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: loginFunction,
                    icon: Image.asset(ImageConstants.googleLogo, height: 24),
                    label: Text(TextConstants.signINGmail),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> loginFunction() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.first == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: "No internet connection");
      return;
    }
    setState(() {
      _isSigningIn = true;
    });

    UserCredential? user = await FirebaseAuthentication().signInWithGoogle();
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFireStore().insertUser(
        UserListModel(
          name: user!.user!.displayName!,
          email: user.user!.email!,
          imageUrl: user.user!.photoURL!,
          createdAt: Timestamp.now(),
          role: "user",
          firebaseUid: user.user!.uid!,
          status: "online",
          lastSeen: Timestamp.now(),
          firebaseToken: token.toString(),
        ),
        user.user!.uid);
    showSuccessToast(
        "${capitalizeFirstLetter(user.user!.displayName!)} is Successfully Login");
    setState(() {
      _isSigningIn = false;
    });
    localDb.setString(
      "username",
      user.user!.displayName!,
    );
    localDb.setString(
      "uuid",
      user.user!.uid,
    );
    await Navigator.pushNamedAndRemoveUntil(
      context,
      '/homeScreen',
      (route) => false,
    );
  }
}
