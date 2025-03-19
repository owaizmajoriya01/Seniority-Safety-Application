import 'package:elderly_care/utils/string_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../utils/shared_pref_helper.dart';
import 'ripple_effect_widget.dart';


enum NotificationType { success, warning, error, info }

class InAppNotificationBody extends StatelessWidget {
  const InAppNotificationBody(
      {Key? key,
      required this.notificationType,
      required this.title,
      this.subtitle,
      this.onCloseTap,
      this.onNotificationTap})
      : super(key: key);

  final NotificationType notificationType;
  final String title;
  final String? subtitle;
  final VoidCallback? onCloseTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor, border: Border.all(color: _borderColor), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.fromLTRB(6, 4, 4, 4),
      child: GestureDetector(
        onTap: onNotificationTap,
        child: Row(
          children: [
            _InAppNotificationIcon(
              notificationType: notificationType,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xff282828))),
                      ),
                  ],
                ),
              ),
            ),
            MyRippleEffectWidget(
                onTap: onCloseTap ??
                    () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                borderRadius: 32,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.black54,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Color get _borderColor {
    switch (notificationType) {
      case NotificationType.success:
        return const Color(0xffbce2c5);
      case NotificationType.warning:
        return const Color(0xfff8dcae);
      case NotificationType.error:
        return const Color(0xfff3c3ba);
      case NotificationType.info:
        return const Color(0xffaacbef);
    }
  }

  Color get _backgroundColor {
    switch (notificationType) {
      case NotificationType.success:
        return const Color(0xffe9f5ec);
      case NotificationType.warning:
        return const Color(0xfffcf5e8);
      case NotificationType.error:
        return const Color(0xfffaebe8);
      case NotificationType.info:
        return const Color(0xffe3edf8);
    }
  }
}

class _InAppNotificationIcon extends StatelessWidget {
  const _InAppNotificationIcon({Key? key, required this.notificationType}) : super(key: key);
  final NotificationType notificationType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(4),
      child: _icon,
    );
  }

  Widget get _icon {
    const double size = 24.0;
    const Color color = Colors.white;
    switch (notificationType) {
      case NotificationType.success:
        return const Icon(
          Icons.check_circle_rounded,
          size: size,
          color: color,
        );
      case NotificationType.warning:
        return const Icon(
          Icons.warning_rounded,
          size: size,
          color: color,
        );
      case NotificationType.error:
        return const Icon(
          Icons.error_rounded,
          size: size,
          color: color,
        );
      case NotificationType.info:
        return const Icon(
          Icons.info_rounded,
          size: size,
          color: color,
        );
    }
  }

  Color get _color {
    switch (notificationType) {
      case NotificationType.success:
        return const Color(0xff38b35a);
      case NotificationType.warning:
        return const Color(0xffec9400);
      case NotificationType.error:
        return const Color(0xffe84d2c);
      case NotificationType.info:
        return const Color(0xff016ae4);
    }
  }
}

class InAppNotificationTestScreen extends StatefulWidget {
  const InAppNotificationTestScreen({Key? key}) : super(key: key);

  @override
  State<InAppNotificationTestScreen> createState() => _InAppNotificationTestScreenState();
}

class _InAppNotificationTestScreenState extends State<InAppNotificationTestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            var data = {
              "body": "Body of Your Notification in Data",
              "title": "Title of Your Notification in Title",
              "priority": "high",
              "content_available": true,
              "checklist_id": "13",
              "location_id": "14",
              "agency_worker_id": "15",
              "caretaker_id": "12",
              "active_stage_id": "2"
            };
            inAppNotificationStream.add(RemoteMessage(data: data));
            return;
          },
          label: const Text("Show Snackbar"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            SelectableText("App Token :${AppPreferenceUtil.getString(SharedPreferencesKey.accessToken)}"),
            const SizedBox(height: 8),
            SelectableText(AppPreferenceUtil.getString(SharedPreferencesKey.fcmToken)),
            Column(
              children: NotificationType.values
                  .map((e) => Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 16),
                        child: InAppNotificationBody(
                            title: "${e.name.capitalize} toast.",
                            subtitle:
                                """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vehicula viverra nulla, 
                                et finibus lorem volutpat et. Donec id blandit odio, eu ultrices erat. 
                                In vulputate odio sed ligula tempus, nec eleifend lacus tincidunt. Donec quis massa semper, 
                                pellentesque felis sed, tincidunt enim. """,
                            notificationType: e),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
