import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
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
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Top Dark Curve
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: screenSize.height * 0.45,
                color: const Color(0xFF0C1D37),
              ),
            ),
          ),

          // Center Leaf Logo
          Align(
            alignment: Alignment(0, -0.3),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 50.h,
                  width: 80.w,
                ),
              ),
            ),
          ),

          // Text Content
          Align(
            alignment: Alignment(0, 0.3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'E-Connect',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0C1D37),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Connect with your loved ones',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0).r,
              child: ElevatedButton(
                onPressed: _isSigningIn ? null : loginFunction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                child: Text(
                  _isSigningIn ? "Loading....." : 'Get Started with Google',
                  style: TextStyle(
                      color: _isSigningIn ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginFunction() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult.first == ConnectivityResult.none) {
    //   Fluttertoast.showToast(msg: "No internet connection");
    //   return;
    // }
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

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
