import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.payload,
    required this.timeStamp,
    required this.isUnread,
  });

  ReceivedNotification.core({
    this.notificationId,
    this.title,
    this.body,
    this.payload,
  })  : timeStamp = DateTime.now().millisecondsSinceEpoch,
        isUnread = true;


  int id = 0;

  final String? notificationId;
  final String? title;
  final String? body;
  final String? payload;
  final int? timeStamp;
  final bool? isUnread;

  factory ReceivedNotification.fromRemoteMessage(RemoteMessage? message) {
    var title = message?.notification?.title ?? message?.data["title"] ?? "-";
    var body = message?.notification?.body ?? message?.data["body"] ?? "-";
    String? payload;
    if (message?.data != null) {
      payload = jsonEncode(message?.data);
    }

    return ReceivedNotification.core(notificationId: message?.messageId, title: title, body: body, payload: payload);
  }

  ReceivedNotification copyWith({
    String? notificationId,
    String? title,
    String? body,
    String? payload,
    int? timeStamp,
    bool? isUnread,
  }) {
    return ReceivedNotification(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      timeStamp: timeStamp ?? this.timeStamp,
      isUnread: isUnread ?? this.isUnread,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'payload': payload,
      'timeStamp': timeStamp,
      'isUnread': isUnread,
    };
  }
}
