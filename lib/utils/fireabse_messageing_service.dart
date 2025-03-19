import 'dart:io';

import 'package:elderly_care/utils/my_notification.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';
import '../repository/auth_repository.dart';

class MyFirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  ///gets permission for notification if any.
  ///
  /// updates firebase token in sharedPref and db
  ///
  /// add listeners for token refresh and foreground notification.
  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }

    _fcm.getToken().then((token) {
      _setFcmToken(token!);
      debugPrint('Debug main token : $token ');
    });

    _fcm.onTokenRefresh.listen((event) {
      _setFcmToken(event);
      debugPrint('Debug main refresh token : $event ');
    });

    MyNotification.init();

    ///foreground message handler
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      debugPrint('Debug FirebaseMessagingService.initialize  foreground message : ${remoteMessage.data.toString()} ');

      inAppNotificationStream.add(remoteMessage);
    });
  }

  ///store firebase token to sharedPref
  _setFcmToken(String token) async {
    debugPrint('Debug MyFirebaseMessagingService._setFcmToken : updated token ');
    final sharedPref = AppPreferenceUtil.instance;

    final isLoggedIn = sharedPref.getBool(SharedPreferencesKey.isLoggedIn);
    final fcmToken = sharedPref.getString(SharedPreferencesKey.fcmToken);
    final uid = sharedPref.getString(SharedPreferencesKey.userId);

    if (fcmToken == token || isLoggedIn == false || uid == null) {
      return;
    }

    sharedPref.setString(SharedPreferencesKey.fcmToken, token);
    AuthRepository().updateToken(uid, token);
  }
}
