import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../widgets/in_app_notification_widget.dart';

class InAppNotification {
  static bool _isVisible = false;

  static Future<void> show(BuildContext context,
      {required String title,
      required String subtitle,
      required NotificationType notificationType,
      VoidCallback? onTap,
      bool showIfAlreadyVisible = false}) async {
    if (!showIfAlreadyVisible && _isVisible) {
      return;
    }

    _isVisible = true;

    _showFlash(context, title, subtitle, notificationType, onTap).then((value) => _isVisible = false);
  }

  static Future<void> showWithSound(BuildContext context,
      {required String title,
      required String subtitle,
      required NotificationType notificationType,
      VoidCallback? onTap,
      bool showIfAlreadyVisible = false}) async {
    if (!showIfAlreadyVisible && _isVisible) {
      return;
    }
    await FlutterRingtonePlayer.playNotification();
    _isVisible = true;

    _showFlash(context, title, subtitle, notificationType, onTap).then((value) => _isVisible = false);
  }

  static Future<void> _showFlash(
    BuildContext context,
    String title,
    String subtitle,
    NotificationType notificationType,
    VoidCallback? onTap,
  ) async {
    return await showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          child: FlashBar(
            padding: EdgeInsets.zero,
            content: InAppNotificationBody(
              notificationType: notificationType,
              title: title,
              subtitle: subtitle,
              onNotificationTap: () {
                if (onTap != null) {
                  onTap();
                  controller.dismiss();
                }
              },
              onCloseTap: () {
                controller.dismiss();
              },
            ),
          ),
        );
      },
    );
  }
}
