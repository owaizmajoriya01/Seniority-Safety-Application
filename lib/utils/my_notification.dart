import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../main.dart';
import '../models/received_notification.dart';
import '../notification_configs.dart';


class MyNotification {
  static final _notification = FlutterLocalNotificationsPlugin();

  static _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        MyNotificationConfig.channelId,
        MyNotificationConfig.channelName,
        channelDescription: MyNotificationConfig.channelDescription,
        importance: Importance.max,
        playSound: true,
        color: Colors.lightGreen,
        channelShowBadge: true,
        // largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        groupKey: MyNotificationConfig.defaultGroupKey,

        groupAlertBehavior: GroupAlertBehavior.children,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static init() async {
    const android = AndroidInitializationSettings("notification_icon");
    final ios = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification.core(
          notificationId: id.toString(),
          title: title,
          body: body,
          payload: payload,
        ),
      );
    });
    final settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings,
        onDidReceiveNotificationResponse: _handleMessageTap,
        onDidReceiveBackgroundNotificationResponse: _handleBackgroundTap);
  }


  //foreground message tap
  static Future<void> _handleMessageTap(NotificationResponse? notificationResponse) async {
    debugPrint('Debug MyNotification._handleMessageTap : ');

    ///Decode payload
    notificationTapStream.add(notificationResponse?.payload);

    /*switch (notificationResponse?.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        selectNotificationStream.add(notificationResponse?.payload);
        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse?.actionId == "navigationActionId") {
          selectNotificationStream.add(notificationResponse?.payload);
        }
        break;
      default:
        selectNotificationStream.add(notificationResponse?.payload);
        break;
    }*/
  }

  static Future<void> _handleBackgroundTap(NotificationResponse? message) async {
    debugPrint('Debug MyNotification._handleBackgroundTap : ${message?.id} ');

  }

  static Future _showNotification({int id = 0, String? title, String? body, Map<String, dynamic>? payload}) async {
    var notificationDetails = await _notificationDetails();
    return _notification.show(id, title, body, notificationDetails, payload: jsonEncode(payload));
  }

  static Future parseAndShowNotification(RemoteMessage remoteMessage) async {
    String? title, body;
    Map<String, dynamic> payload;
    int id;
    payload = remoteMessage.data;
    if (remoteMessage.notification == null) {
      title = remoteMessage.data['title'];
      body = remoteMessage.data['body'];
      id = remoteMessage.messageId.hashCode;
    } else {
      title = remoteMessage.notification!.title;
      body = remoteMessage.notification!.body;
      id = remoteMessage.messageId.hashCode;
    }

    _showNotification(id: id, title: title, body: body, payload: payload);
  }

  static Future showNotification({required String title, required String body}) async {
    var notificationDetails = await _notificationDetails();
    return _notification.show(0, title, body, notificationDetails);
  }

  static Future<void> showInboxNotification(int id) async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name',
        channelDescription: 'inbox channel description', groupKey: 'msg', styleInformation: inboxStyleInformation);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notification.show(id, 'inbox title', 'inbox body', platformChannelSpecifics);
  }
}
