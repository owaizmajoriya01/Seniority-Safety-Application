import 'dart:convert';

class MyNotification {
  final String? uid;
  final String? from;
  final String? to;
  final String? title;
  final String? subtitle;
  final String? notificationType;
  final int? timeStamp;

  const MyNotification({
    this.uid,
    this.from,
    this.title,
    this.to,
    this.subtitle,
    this.notificationType,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'from': from,
      'to': to,
      'title': title,
      'subtitle': subtitle,
      'notificationType': notificationType,
      'timeStamp': timeStamp,
    };
  }

  factory MyNotification.fromMap(Map<String, dynamic> map) {
    return MyNotification(
      uid: map['uid'],
      from: map['from'],
      to: map['to'],
      title: map['title'],
      subtitle: map['subtitle'],
      notificationType: map['notificationType'],
      timeStamp: map['timeStamp'],
    );
  }

  MyNotification copyWith({
    String? uid,
    String? from,
    String? title,
    String? subtitle,
    String? notificationType,
    int? timeStamp,
  }) {
    return MyNotification(
      uid: uid ?? this.uid,
      from: from ?? this.from,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      notificationType: notificationType ?? this.notificationType,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }
}

class SendNotificationData {
  SendNotificationData(
      this.to, this.title, this.subTitle, this.notificationType);

  final String? to;
  final String? title;
  final String? subTitle;
  final String? notificationType;

  Map<String, String> toNotificationData() => {
        "data": jsonEncode({
          "title": title ?? "",
          "subtitle": subTitle ?? "",
          "notificationType": notificationType ?? "",
        })
      };

  factory SendNotificationData.fromMyNotification(
      MyNotification notification, token) {
    return SendNotificationData(token, notification.title,
        notification.subtitle, notification.notificationType);
  }
}
