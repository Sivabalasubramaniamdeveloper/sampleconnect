
import 'package:flutter/material.dart';
import '../../Screens/UserList/Presentation/user_list.dart';
import '../../Screens/Home/home_screen.dart';
import '../../Screens/Login/Presentation/auto_login.dart';
import '../../Screens/Login/Presentation/login_screen.dart';
import '../../Screens/microsoft/Microsoft.dart';



final Map<String, WidgetBuilder> appRoutes = {
  // '/': (context) => AutoLogin(),
  // '/': (context) => Localdb(),
  '/': (context) => MicroSoftLogin(),
  '/gmailAuth': (context) => GmailAuthPage(),
  '/homeScreen': (context) => HomeScreen(),
  '/chatList': (context) => ChatList(),
};
