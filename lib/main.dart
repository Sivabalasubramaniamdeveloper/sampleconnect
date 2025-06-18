import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'Firebase/LocalNotification.dart';
import 'Firebase/PushNotification.dart';
import 'Firebase/db/db.dart';
import 'Screens/Personalchat/cubit/chat_message_cubit.dart';
import 'Screens/UserList/cubit/user_list_cubit.dart';
import 'Utils/Constants/AppRoutes.dart';
import 'Utils/Theme/ThemeCubit/ThemeCubit.dart';

late final Database localDB;
late final FirebaseAuth auth;
late final FirebaseApp app;
String? isNavigating;
final GlobalKey<NavigatorState> navigatorsKey = GlobalKey<NavigatorState>();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    if (inDebug) {
      return ErrorWidget(details.exception);
    }
    return Center(
      child: Card(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Error :\n${details.exception}',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  };
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  localDB = await DBHelper().database;
  app = await Firebase.initializeApp();
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  auth = FirebaseAuth.instanceFor(app: app);
  await LocalNotification.localInit();
  await PushNotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorsKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<UserListCubit>(
          create: (context) => UserListCubit(),
        ),
        BlocProvider<ChatMessageCubit>(
          create: (context) => ChatMessageCubit(),
        ),
      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(412, 846),
          builder: (context, child) {
            return BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, theme) {
              return MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                routes: appRoutes,
                initialRoute: '/',
                navigatorKey: navigatorsKey,
                theme: theme,
              );
            });
          }),
    );
  }
}
