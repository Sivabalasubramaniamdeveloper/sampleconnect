
import 'package:flutter/material.dart';

import '../../Screens/ChatList/Presentation/chat_list.dart';
import '../../Screens/Login/Presentation/auto_login.dart';
import '../../Screens/Login/Presentation/login_screen.dart';



final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => AutoLogin(),
  // '/': (context) => Localdb(),
  // '/': (context) => MicroSoftLogin(),
  '/gmailAuth': (context) => GmailAuthPage(),
  '/chatList': (context) => ChatList(),
};
