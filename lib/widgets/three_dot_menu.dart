import 'package:elderly_care/provider/auth_provier.dart';
import 'package:elderly_care/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

enum PopUpMenuEnum {
  notification("Notification"),
  profile("Profile"),
  logout("Logout");

  final String value;

  const PopUpMenuEnum(this.value);
}

class ThreeDotMenu extends StatelessWidget {
  const ThreeDotMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => PopUpMenuEnum.values
          .map(
            (e) => PopupMenuItem<PopUpMenuEnum>(
              value: e,
              child: Text(e.value),
            ),
          )
          .toList(),
      onSelected: (value) {
        switch (value) {
          case PopUpMenuEnum.notification:
            navigateToNotification(context);
            break;
          case PopUpMenuEnum.profile:
            navigateToProfile(context);
            break;
          case PopUpMenuEnum.logout:
            logoutAndNavigate(context);
            break;
        }
      },
      icon: const Icon(Icons.more_vert),
    );
  }

  void logoutAndNavigate(BuildContext context) {
    context.read<AuthProvider>().logout().whenComplete(() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
    });
  }

  void navigateToProfile(BuildContext context) {
    var user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileScreen(
                    user: user,
                  )));
    }
  }

  void navigateToNotification(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
  }
}
