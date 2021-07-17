import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kisanweb/Helpers/helper.dart';

/*
showAwesomeNotifications(RemoteMessage message) {
  RemoteNotification notification = message.notification;

  Map<String, String> payLoad = {};
  message.data.forEach((key, value) {
    payLoad.addAll({key: value});
  });
  print(payLoad);

  if ((message.data['action']??"no") == "custom") {
    if (message.data['notification_action'] == "org_event_promotion") {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: '10000',
            title: parseHtmlString(message.data['description'] ?? "title"),
            body: 'Event that may interest you!',
            largeIcon: message.data['owner_image_url'] ?? "",
            hideLargeIconOnExpand: true,
            bigPicture: message.data['image_url'] ?? "",
            notificationLayout: NotificationLayout.BigPicture,
            payload: payLoad,
            autoCancel: false,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "see",
              label: "SEE DETAILS",
            )
          ]);
    } else if (message.data['notification_action'] == "org_product_promotion") {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: '10000',
            title: parseHtmlString(
                message.data['owner_organisation_name'] ?? "title"),
            body: 'has invited you to see their product' +
                " " +
                parseHtmlString(message.data['description'] ?? ""),
            largeIcon: message.data['owner_image_url'] ?? "",
            hideLargeIconOnExpand: true,
            bigPicture: message.data['image_url'] ?? "",
            notificationLayout: NotificationLayout.BigPicture,
            payload: payLoad,
            autoCancel: false,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "see",
              label: "SEE DETAILS",
            ),
          ]);
    } else if (message.data['notification_action'] == "custom" ||
        message.data['notification_action'] == "org_custom_promotion") {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: '10000',
            title: parseHtmlString(message.data['title'] ?? "title"),
            largeIcon: message.data['image_url'] ?? "",
            hideLargeIconOnExpand: true,
            bigPicture: message.data['image_url'] ?? "",
            notificationLayout: NotificationLayout.BigPicture,
            payload: payLoad,
            autoCancel: false,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "see",
              label: "SEE DETAILS",
            ),
          ]);
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: '10000',
            title: notification.title ?? "title",
            body: notification.body ?? "body"),
      );
    }
  } else {

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: Random().nextInt(1000),
          channelKey: '10000',
          title: message.data['nt'],
          body: message.data['nm']),
    );
  }
}
*/
