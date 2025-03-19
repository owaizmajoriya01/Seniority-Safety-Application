import 'package:elderly_care/provider/admin_ui_state.dart';
import 'package:elderly_care/provider/audio_note_provider.dart';
import 'package:elderly_care/provider/auth_provier.dart';
import 'package:elderly_care/provider/caretaker_profile_provider.dart';
import 'package:elderly_care/provider/caretaker_provider.dart';
import 'package:elderly_care/provider/elder_provider.dart';
import 'package:elderly_care/screens/splash_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'screens/login_screen.dart';

///use of this navigator is to dispose and initialize providers only when sales section is opened.
class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key, this.initialRoute}) : super(key: key);

  ///initial route after login in
  ///
  /// default value is [AppRoutes.caretakerDashBoard]
  final AppRoutes? initialRoute;

  @override
  State<AppNavigator> createState() => AppNavigatorState();
}

class AppNavigatorState extends State<AppNavigator> {
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var notificationRoute = await NotificationNavigationHandler().handleBackgroundTap();
      if (notificationRoute != null) {
        _navigatorKey.currentState?.pushNamed(notificationRoute.name);
      }
      final remoteConfig = FirebaseRemoteConfig.instance;
      if (remoteConfig.lastFetchTime.isAfter(DateTime.now().add(const Duration(days: 1)))) {
        await remoteConfig.fetchAndActivate();
      }
      var packageInfo = await PackageInfo.fromPlatform();
      var value = remoteConfig.getAll();
      var appVersion = value["app_version"]?.asString();
      var buildNumber = value["build_number"]?.asString();

      if (appVersion != packageInfo.version || buildNumber != packageInfo.buildNumber) {
       // _navigatorKey.currentState
       //     ?.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const ContactPage()), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminUiState()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ElderProvider()),
        ChangeNotifierProvider(create: (_) => CaretakerProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AudioNoteProvider()),
      ],
      child: WillPopScope(
        onWillPop: () async {
          var result = await _navigatorKey.currentState!.maybePop();
          if (result == false) {
            //Navigator.pop(context);
            _navigatorKey.currentState?.pop();
          }
          return !result;
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: widget.initialRoute?.name ?? AppRoutes.splash.name,
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            var route = AppRoutes.values.firstWhere((element) => element.name == settings.name);
            switch (route) {
              case AppRoutes.splash:
                builder = (BuildContext context) => const SplashScreen();
                break;

              case AppRoutes.login:
                builder = (BuildContext context) => const LoginScreen();
                break;
              default:
                throw Exception(
                    'Avoid Named routes for now. Use anonymous routing (i.e MaterialPageRoute). if Named routes are necessary then add those routes in this switch');
            }
            return MaterialPageRoute<void>(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }
}

enum AppRoutes { login, caretakerDashBoard, splash, contact }
