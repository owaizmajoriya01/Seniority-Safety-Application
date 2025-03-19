import 'dart:collection';

import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/models/notification.dart';
import 'package:elderly_care/repository/notification_repository.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  var isLoading = false;
  final _notifications = <MyNotification>[];

  List<MyNotification> get notification => UnmodifiableListView(_notifications);

  NotificationProvider() {
    init();
  }

  init() {
    _loadNotifications().then((value) {
      notifyListeners();
    });
  }

  Future<void> _loadNotifications() async {
    var isAdmin = AppPreferenceUtil.getString(SharedPreferencesKey.userType) == UserRoleEnum.admin.name;
    var uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    if (isAdmin) {
      var response = await NotificationRepository().getAllNotifications();
      if (response.success) {
        _notifications.addAll(response.data);
      }
    } else {
      var response = await NotificationRepository().getNotificationByReceiverUid(uid);
      if (response.success) {
        _notifications.addAll(response.data);
      }
    }
  }

  void _refreshNotification() {
    _notifications.clear();
    _loadNotifications();
    notifyListeners();
  }
}
