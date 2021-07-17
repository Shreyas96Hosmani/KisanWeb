import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

awesome_notification_init() {
  AwesomeNotifications().initialize(
      'resource://drawable/logo',
    [
      NotificationChannel(
          channelKey: '10000',
          channelName: 'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          defaultColor: Color(0xFF00A651),
          ledColor: Color(0xFF00A651),
          enableVibration: true,
          importance: NotificationImportance.High)
    ],
  );
}

