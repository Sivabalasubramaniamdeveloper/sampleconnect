import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//local notification
  static Future localInit() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    // Check if the app was launched from a notification (when terminated)
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      _handleNotificationClick(details!.notificationResponse?.payload);
    }

    // Request notification permission for Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<String> getInitNotif() async {
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      String? payload = details?.notificationResponse?.payload;
      return (payload == "0" ||
          payload == "-1" ||
          payload == "-2" ||
          payload!.startsWith("file://") ||
          payload.endsWith(".pdf") ||
          payload.endsWith(".jpg"))
          ? "dashboard"
          : "dashboard";
    }
    return "dashboard";
  }

  static Future<String?> getNotificationPayload() async {
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    return details?.notificationResponse?.payload;
  }

  static bool _isFileOpened = false; // Local flag to track if file was opened

  static void _handleNotificationClick(String? payload) {
    if (payload == null) return;

    if (payload.startsWith("file://") ||
        payload.endsWith(".pdf") ||
        payload.endsWith(".jpg")) {
      if (!_isFileOpened) {
        OpenFile.open(payload);
      }
      navigatorsKey.currentState
          ?.pushReplacementNamed('Dashboard', arguments: payload);
    } else if (payload == "0" || payload == "-1" || payload == "-2") {
      navigatorsKey.currentState
          ?.pushReplacementNamed('Dashboard', arguments: payload);
    } else {
      navigatorsKey.currentState
          ?.pushReplacementNamed('Dashboard', arguments: payload);
    }
  }

//simple Notification
  static Future simpleNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails androidNotificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
        iOS: DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, androidNotificationDetails, payload: payload);
  }

  static Future<void> scheduleRepeatingNotification(
      String title,
      String body,
      DateTime scheduledDate,
      DateTimeComponents dateTimeComponent,
      int id,
      ) async {
    NotificationDetails androidNotificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel",
        'Recurring Notifications',
        channelDescription: 'Channel for repeating notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), androidNotificationDetails,
        // uiLocalNotificationDateInterpretation:
        // UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
        dateTimeComponent, // Triggers on the selected interval
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: id.toString());
  }

  static Future<void> scheduleCancelOfRepeatingNotification(
      int id, DateTime endDateTime) async {
    final Duration delay = endDateTime.difference(DateTime.now());

    if (delay.isNegative) {
      await _flutterLocalNotificationsPlugin.cancel(id);
      return;
    }

    Future.delayed(delay, () async {
      await _flutterLocalNotificationsPlugin.cancel(id);
    });
  }

  //schedule Notification
  static Future scheduleNotification(
      String title, String body, DateTime scheduledDate, int id) async {
    const NotificationDetails androidNotificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
        iOS: DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      androidNotificationDetails,
      // uiLocalNotificationDateInterpretation:
      // UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  //show perodic Notification
  static Future showPerodicNotification({
    required String titile,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel 2', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        1, titile, body, RepeatInterval.everyMinute, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  }

  //stop notification
  static Future cancel(id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}

