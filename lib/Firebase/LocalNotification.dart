import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


//local notification
  static Future localInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
// ?    final DarwinInitializationSettings initializationSettingsDarwin =
    // DarwinInitializationSettings(
    //     onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        // iOS: initializationSettingsDarwin,
        // linux: initializationSettingsLinux
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => null);
  }

//simple Notification
  static Future simpleNotification({
    required String titile,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker', icon: '@mipmap/ic_launcher');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, titile, body, notificationDetails, payload: payload);
  }

   //show perodic Notification
  // static Future showPerodicNotification({
  //   required String titile,
  //   required String body,
  //   required String payload,
  // }) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails('channel 2', 'your channel name',
  //       channelDescription: 'your channel description',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker', icon: '@mipmap/ic_launcher');
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidNotificationDetails);
  //   await _flutterLocalNotificationsPlugin.periodicallyShow(1, titile, body, RepeatInterval.everyMinute, notificationDetails);
  // }

  //stop notification
  static Future cancel(id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

}
