import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    DarwinInitializationSettings iosSeetings = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initializationSetting = InitializationSettings(iOS: iosSeetings, macOS: iosSeetings);
    flutterLocalNotificationsPlugin.initialize(initializationSetting);
  }

  Future<void> _showNotificationWithSubtitle() async {
    print("notif");
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(subtitle: 'the subtitle');
    const NotificationDetails notificationDetails =
        NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin.show(1, 'title of notification with a subtitle',
        'body of notification with a subtitle', notificationDetails,
        payload: 'item x');
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      // setState(() {
      //   _notificationsEnabled = granted ?? false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("IOS LOCAL NOTIF"),
        ),
        body: Center(
          child: TextButton(
              onPressed: () async {
                await _showNotificationWithSubtitle();
              },
              child: const Text("SHOW NOTIFICATION")),
        ),
      ),
    );
  }
}
