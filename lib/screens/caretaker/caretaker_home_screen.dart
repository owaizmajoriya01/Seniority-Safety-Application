import 'package:elderly_care/my_theme.dart';
import 'package:elderly_care/screens/caretaker/add_pill.dart';
import 'package:elderly_care/screens/caretaker/calendar_screen.dart';
import 'package:elderly_care/screens/caretaker/elder_list_sceen.dart';
import 'package:elderly_care/screens/caretaker/send_donation_screen.dart';
import 'package:elderly_care/widgets/ripple_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../provider/caretaker_provider.dart';
import '../../repository/auth_repository.dart';
import '../../utils/location_utils.dart';
import '../../utils/shared_pref_helper.dart';
import '../../widgets/no_data_found_widget.dart';
import '../admin/admin_home_screen.dart';
import '../audio_note_screen.dart';
import '../elder/elder_home_screen.dart';
import 'add_reminder.dart';

class CareTakerHomeScreen extends StatefulWidget {
  const CareTakerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CareTakerHomeScreen> createState() => _CareTakerHomeScreenState();
}

class _CareTakerHomeScreenState extends State<CareTakerHomeScreen> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateLocation();
    });
  }

  Future<void> _updateLocation() async {
    var locationUtils = LocationUtils();
    var result = await locationUtils.handlePermissionWithDialog(context);
    if (locationUtils.hasPermission(result)) {
      var locationSettings = const LocationSettings(distanceFilter: 5);
      var authRepo = AuthRepository();
      var uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
      var initialPosition = await Geolocator.getCurrentPosition();
      authRepo.updateLatLong(uid, initialPosition);
      Geolocator.getPositionStream(locationSettings: locationSettings).listen((event) {
        authRepo.updateLatLong(uid, event);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeScreenTopSection(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 16),
              child: Row(
                children: const [
                  Expanded(child: _AddReminderButton()),
                  SizedBox(width: 16),
                  Expanded(child: _AddPillButton()),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: IconButtonWithText(
                    title: "Assigned \nElders",
                    icon: SvgPicture.asset("assets/svgs/view_all.svg"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ElderListScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: IconButtonWithText(
                    title: "Audio Notes ",
                    icon: SvgPicture.asset("assets/svgs/audio_note.svg"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AudionNoteListScreen()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(width: double.infinity, child: _GiveDonationButton()),
            const SizedBox(height: 20),
            const Expanded(child: _UpcomingEventsSection()),
          ],
        ),
      )),
    );
  }
}

class _AddReminderButton extends StatelessWidget {
  const _AddReminderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(6),
      child: MyRippleEffectWidget(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReminder()));
        },
        child: SizedBox(
          height: 100,
          width: size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SvgPicture.asset("assets/svgs/add_note.svg", width: size.width * 0.25),
                const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "+ Add\n   Reminder",
                      style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddPillButton extends StatelessWidget {
  const _AddPillButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(6),
      child: MyRippleEffectWidget(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPillReminderScreen()));
        },
        child: SizedBox(
          height: 100,
          width: size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SvgPicture.asset("assets/svgs/pill.svg", width: size.width * 0.25),
                const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "+ Add\n   Pills",
                      style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GiveDonationButton extends StatelessWidget {
  const _GiveDonationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(6),
      child: MyRippleEffectWidget(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SendDonationScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/svgs/donate.svg",
                width: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Make Donation",
                      style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "to old age homes",
                      style: TextStyle(fontSize: 14, color: MyTheme.darkGray, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingEventsSection extends StatelessWidget {
  const _UpcomingEventsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CaretakerProvider>(builder: (context, provider, child) {
      if (provider.events.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: NoDataFound(
                message: "No Events found",
              ),
            ),
          ],
        );
      } else {
        var halfHour = 1000 * 60 * 30;
        var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
        var upcoming = provider.events.where((element) => element.timeStamp > (currentTimeStamp - halfHour)).toList();
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Upcoming events",
                  style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600)),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
                  },
                  child: const Text("View All ▼",
                      style: TextStyle(fontSize: 12, color: MyTheme.primaryColor, fontWeight: FontWeight.w600))),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: upcoming.length, itemBuilder: (_, index) => EventsWidget(event: upcoming[index])))
        ]);
      }
    });
  }
}
