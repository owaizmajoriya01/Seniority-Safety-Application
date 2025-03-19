import 'package:collection/collection.dart';
import 'package:elderly_care/utils/date_utils.dart';

class MyEvent {
  final String uid;
  final String senderUid;
  final String receiverUid;
  final String senderName;
  final String receiverName;
  final int eventType;
  final int timeStamp;
  final String note;
  final String? name;
  final bool isCompleted;
  final int? completedTimeStamp;

  const MyEvent({
    required this.uid,
    required this.senderUid,
    required this.receiverUid,
    required this.senderName,
    required this.receiverName,
    required this.eventType,
    required this.timeStamp,
    required this.note,
    this.name,
    this.isCompleted = false,
    this.completedTimeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'senderName': senderName,
      'receiverName': receiverName,
      'eventType': eventType,
      'timeStamp': timeStamp,
      'note': note,
      'name': name,
      "isCompleted": isCompleted,
      "completedTimeStamp": completedTimeStamp
    };
  }

  factory MyEvent.fromMap(Map<String, dynamic> map) {
    return MyEvent(
      uid: map['uid'] ?? "",
      senderUid: map['senderUid'] ?? "",
      receiverUid: map['receiverUid'] ?? "",
      senderName: map['senderName'] ?? "",
      receiverName: map['receiverName'] ?? "",
      eventType: map['eventType'] ?? 1,
      timeStamp: map['timeStamp'] ?? 0,
      note: map['note'] ?? "",
      name: map['name'] ?? "",
      isCompleted: map['isCompleted'] ?? false,
      completedTimeStamp: map['completedTimeStamp'] ?? 0,
    );
  }

  String get formattedDateTime => MyDateUtils.parseTimeStamp(timeStamp);

  MyEvent copyWith({
    String? uid,
    String? senderUid,
    String? receiverUid,
    String? senderName,
    String? receiverName,
    int? eventType,
    int? timeStamp,
    String? note,
    String? name,
    bool? isCompleted,
    int? completedTimeStamp,
  }) {
    return MyEvent(
      uid: uid ?? this.uid,
      senderUid: senderUid ?? this.senderUid,
      receiverUid: receiverUid ?? this.receiverUid,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      eventType: eventType ?? this.eventType,
      timeStamp: timeStamp ?? this.timeStamp,
      note: note ?? this.note,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      completedTimeStamp: completedTimeStamp ?? this.completedTimeStamp,
    );
  }
}

enum EventType {
  reminder("Reminder"),
  pills("Pills"),
  visit("Visit"),
  tests("Tests"),
  appointment("Doctor's Appointment");

  final String name;

  const EventType(this.name);

  static int eventTypeToInt(EventType eventType) {
    return eventType.index;
  }

  static EventType intToEventType(int eventTypeInt) {
    return EventType.values[eventTypeInt];
  }

  static EventType nameToEventType(String name) {
    var result = EventType.values.firstWhereOrNull((element) => element.name == name);
    return result ?? EventType.reminder;
  }
}
