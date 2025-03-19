import 'package:elderly_care/models/notification.dart';
import 'package:elderly_care/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../my_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: "Notifications",
        ),
        //body: _NoNewNotification());
        body: SizedBox.expand(
          child: Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              if (provider.notification.isNotEmpty) {
                var list = provider.notification;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      var notification = list[index];
                      return _Notification(notification);
                    });
              } else {
                return const _NoNewNotification();
              }
            },
          ),
        ));
  }
}

class _Notification extends StatelessWidget {
  const _Notification(this.notification, {Key? key}) : super(key: key);

  final MyNotification notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        decoration: BoxDecoration(color: _color, borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title ?? "-",
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(notification.subtitle ?? "-", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),
              Text(_date, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Color get _color {
    if (notification.notificationType == "") {
      return MyTheme.primaryColor.withOpacity(0.2);
    } else {
      return Colors.white;
    }
  }

  String get _date {
    try {
      if (notification.timeStamp == null) return "-";
      return MyDateUtils.parseDate(
          date: DateTime.fromMillisecondsSinceEpoch(notification.timeStamp ?? 0), toDateFormat: "yyyy MM dd, hh: mm a");
    } catch (e) {
      return "-";
    }
  }
}

class _NoNewNotification extends StatelessWidget {
  const _NoNewNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(
          flex: 1,
        ),
        SizedBox(width: size.width * 0.6, height: size.height * 0.3, child: SvgPicture.asset("assets/svg/done.svg")),
        Text(
          "You're all caught up!\nCheck back later for new \nnotifications",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xff261200), fontWeight: FontWeight.w500),
        ),
        const Spacer(
          flex: 3,
        ),
      ]),
    );
  }
}
