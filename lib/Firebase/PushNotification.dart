import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sampleconnect/Screens/Personalchat/Presentation/Widgets/Messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LocalNotification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    String payloadData = jsonEncode(message.data);
    print("ssssssssssssssssssss");
    LocalNotification.simpleNotification(
      titile: message.notification!.title!,
      body: message.notification!.body!,
      payload: payloadData,
    );
  }
}

class PushNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission_Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Provisional_Permission_Granted');
    } else {
      print('Permission_Denied');
    }
  }

  Future<String> getDeviceToken() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    String? token = await messaging.getToken();
    await localDb.setString("firebaseToken", token!);
    return token;
  }

  Future<void> init() async {
    // Request permission for iOS devices
    requestNotificationPermission();
    getDeviceToken();
    // Generate the token and save it locally

    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print('APNs Token: $apnsToken');

    // Setup background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup the notification channel for Android
    await setupFlutterNotifications();

    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(message);
        showFlutterNotification(message);
      } else {
        showFlutterNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });

    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }



  handleMessage(RemoteMessage message) {
    print("messagesssssssss");
    print(message);
    print(message);
    print(message);
  }

  Future<void> setupFlutterNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    // Create the Android notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Initialize the plugin for displaying notifications on the device
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Set foreground notification presentation options for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitializationSettings = DarwinInitializationSettings();

    var initializeSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializeSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(message);
    });
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Make sure this matches your channel ID
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            icon: 'launch_background', // Change this to your app's icon
          ),
        ),
      );
    }
  }
}
