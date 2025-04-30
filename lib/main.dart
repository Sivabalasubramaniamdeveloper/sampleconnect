import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'Firebase/LocalNotification.dart';
import 'Firebase/PushNotification.dart';
import 'Firebase/db/db.dart';
import 'Utils/Constants/AppRoutes.dart';
import 'Utils/Theme/ThemeCubit/ThemeCubit.dart';

late final Database localDB;
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
  await Firebase.initializeApp();
  await PushNotificationService().init();
  await LocalNotification.localInit();

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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
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
