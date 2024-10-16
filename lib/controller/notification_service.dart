import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:urusanku_app/main.dart';
import 'package:urusanku_app/page/notification.dart';

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );
  }

  static Future refreshToken() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");

    final token = await _firebaseMessaging.getToken();

    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (uid != null) {
        await ref.update({
          "fcmToken": token
        });
      }
    });
  }

  static Future localNotificationInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin
    );

    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onNotificationTap, onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => NotificationPage()));
  }

  static Future showSimpleNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'channel_name', channelDescription: 'notifications', importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}