import 'dart:collection';

import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/models/my_events.dart';
import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/models/notification.dart';
import 'package:elderly_care/repository/assigned_repository.dart';
import 'package:elderly_care/repository/events_repository.dart';
import 'package:elderly_care/repository/notification_repository.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';

class CaretakerProvider with ChangeNotifier {
  final _assignedUsers = <MyUser>[];
  final _events = <MyEvent>[];

  List<MyUser> get assignedUsers => UnmodifiableListView(_assignedUsers);

  List<MyEvent> get events => UnmodifiableListView(_events);

  CaretakerProvider() {
    init();
  }

  init() {
    Future.wait([_getAssignedElders(), _fetchEventsByCareTaker()]).then((value) {
      notifyListeners();
    });
  }

  Future<void> _getAssignedElders() async {
    var uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);

    var elders = await AssignedRepository().getEldersAssignedTo(uid);
    debugPrint('Debug CaretakerProvider._getAssignedElders : ${elders.data.length}');
    if (elders.success && elders.data.isNotEmpty) {
      _assignedUsers.addAll(elders.data);
    }
  }

  Future<ApiResponse> createEvent(MyEvent event, MyUser? selectedUser) async {
    var response = await EventsRepository().addEvent(event);
    if (response.success) {
      NotificationRepository().sendNotification(
          MyNotification(
              from: event.senderUid,
              to: event.receiverUid,
              title: "Added new ${EventType.intToEventType(event.eventType)}"),
          selectedUser?.deviceToken);
    }

    return response;
  }

  Future<void> _fetchEventsByCareTaker() async {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var events = await EventsRepository().getAllEventBySenderId(uid);
    if (events.success && events.data.isNotEmpty) {
      _events.clear();
      _events.addAll(events.data);
    }
  }

  Future<void> refreshEvents() async {
    await _fetchEventsByCareTaker();
    notifyListeners();
  }
}
