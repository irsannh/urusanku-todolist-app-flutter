import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:urusanku_app/controller/notification_service.dart';
import 'package:urusanku_app/page/notification.dart';
import 'package:urusanku_app/page/splash_screen.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification received in background");
  }
}

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  await NotificationService.localNotificationInit();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Notification Tapped");
    }
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => NotificationPage()));
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message in foreground");
    if (message.notification != null) {
      NotificationService.showSimpleNotification(title: message.notification!.title!, body: message.notification!.body!);
    }
  });

  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print('Got a message in terminate');
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => NotificationPage()));
    });
  }

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}


