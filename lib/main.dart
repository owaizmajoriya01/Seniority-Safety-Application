import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_navigator.dart';
import 'firebase_options.dart';
import 'models/received_notification.dart';
import 'my_theme.dart';
import 'utils/fireabse_messageing_service.dart';
import 'utils/in_app_notification.dart';
import 'utils/my_notification.dart';
import 'utils/shared_pref_helper.dart';
import 'widgets/in_app_notification_widget.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  debugPrint('Debug _firebaseMessagingBackgroundHandler background message : ${message?.data.toString()} ');
  if (message?.notification == null) {
    MyNotification.init();
    MyNotification.parseAndShowNotification(message!);
  }
}

/// Stream for handling when a notification is triggered while the app is
/// in the foreground.
///
/// This is only applicable to iOS versions older than 10.
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

/// Stream for handling  notification click while the app is
/// in the foreground.
final StreamController<String?> notificationTapStream = StreamController<String?>.broadcast();

final StreamController<RemoteMessage> inAppNotificationStream = StreamController<RemoteMessage>.broadcast();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppPreferenceUtil.init();
  await MyNotification.init();
  await MyFirebaseMessagingService().initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //app is in foreground

    inAppNotificationStream.stream.listen((event) {
      //DbNotificationHelper().addItem(ReceivedNotification.fromRemoteMessage(event));
      _showInAppNotification(event);
    });
    //app is in foreground
    notificationTapStream.stream.listen((event) {
      NotificationNavigationHandler().handleForegroundNotificationTap(event);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var packageInfo = await PackageInfo.fromPlatform();

      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setDefaults({
        "app_version": packageInfo.version,
        "build_number": packageInfo.buildNumber,
      });
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(days: 1),
      ));
    });
  }

  @override
  void dispose() {
    inAppNotificationStream.close();
    notificationTapStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Elderly Care',

      theme: ThemeData(
          fontFamily: 'HankenGrotesk',
          scaffoldBackgroundColor: MyTheme.whiteScaffoldColor,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: MyTheme.primarySwatch)
              .copyWith(secondary: MyTheme.accentColor, tertiary: MyTheme.secondaryAccentColor)),
      home: const SafeArea(child: AppNavigator()),
      //home: const TestScreen(),
    );
  }

  void _showInAppNotification(RemoteMessage remoteMessage) {
    var title = remoteMessage.notification?.title ?? remoteMessage.data['title'] ?? "-";
    var subtitle = remoteMessage.notification?.body ?? remoteMessage.data['body'] ?? "-";

    MyNotification.parseAndShowNotification(remoteMessage);
    InAppNotification.showWithSound(NavigationService.navigatorKey.currentContext!,
        title: title, subtitle: subtitle, notificationType: NotificationType.info, onTap: () {
      NotificationNavigationHandler().handleForegroundTapWithRemoteMessage(remoteMessage);
    });
  }
}

class NotificationNavigationHandler {
  String _extractPayload(RemoteMessage remoteMessage) {
    return jsonEncode(remoteMessage.data);
  }

  ///return [AppRoutes] after parsing notification data.
  ///
  /// Instead of returning the route, navigation could be handled within this method.
  Future<AppRoutes?> handleBackgroundTap() async {
    try {
      var _ = await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();

      ///parse notification data and return route information.
    } catch (_) {}

    return null;
  }

  /// encode [remoteMessage] and passes it as parameter to [handleForegroundNotificationTap]
  void handleForegroundTapWithRemoteMessage(RemoteMessage? remoteMessage) {
    if (remoteMessage == null) return;
    var payload = _extractPayload(remoteMessage);
    handleForegroundNotificationTap(payload);
  }

  ///make sure to use this method only when app is in foreground.
  void handleForegroundNotificationTap(String? payload) {
    //var context = NavigationService.navigatorKey.currentContext!;
    //parse payload and Navigate using navigator.
    //Navigator.push(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
