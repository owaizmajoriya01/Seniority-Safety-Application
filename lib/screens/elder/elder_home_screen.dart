import 'package:elderly_care/provider/auth_provier.dart';
import 'package:elderly_care/repository/auth_repository.dart';
import 'package:elderly_care/utils/location_utils.dart';
import 'package:elderly_care/utils/url_launcher_utils.dart';
import 'package:elderly_care/widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../models/my_user.dart';
import '../../my_theme.dart';
import '../../provider/elder_provider.dart';
import '../../utils/shared_pref_helper.dart';
import '../../widgets/three_dot_menu.dart';
import '../admin/admin_home_screen.dart';
import '../audio_note_screen.dart';
import '../caretaker/calendar_screen.dart';
import '../caretaker/elder_list_sceen.dart';

class ElderHomeScreen extends StatefulWidget {
  const ElderHomeScreen({Key? key}) : super(key: key);

  @override
  State<ElderHomeScreen> createState() => _ElderHomeScreenState();
}

class _ElderHomeScreenState extends State<ElderHomeScreen> {
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
                child: Consumer<ElderProvider>(builder: (context, provider, child) {
                  return _MyCaretakerSection(caretaker: provider.assignedCaretakers.firstOrNull);
                })),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonWithText(
                    title: "View nearby\nHospitals ",
                    icon: SvgPicture.asset("assets/svgs/health.svg"),
                    onTap: () {
                      UrlLauncherUtil().launchHospitalMap();
                    },
                  ),
                  IconButtonWithText(
                    title: "Audio Notes ",
                    icon: SvgPicture.asset("assets/svgs/audio_note.svg"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AudionNoteListScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(child: _UpcomingEventsSection()),
          ],
        ),
      )),
    );
  }
}

class _MyCaretakerSection extends StatelessWidget {
  const _MyCaretakerSection({Key? key, this.caretaker}) : super(key: key);

  final MyUser? caretaker;

  @override
  Widget build(BuildContext context) {
    if (caretaker == null) {
      return const SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My CareTaker",
              style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600)),
          _AssignedCaretaker(
            caretaker: caretaker!,
          )
        ],
      );
    }
  }
}

class _AssignedCaretaker extends StatelessWidget {
  const _AssignedCaretaker({Key? key, required this.caretaker}) : super(key: key);
  final MyUser? caretaker;

  @override
  Widget build(BuildContext context) {
    if (caretaker == null) {
      return const Text("No Caretaker is assigned to you. Please contact admin.");
    } else {
      return UserItemWithButtons(
        user: caretaker,
        showLocateButton: false,
      );
    }
  }
}

class _UpcomingEventsSection extends StatelessWidget {
  const _UpcomingEventsSection({Key? key}) : super(key: key);

//TODO: Add an option to mark event as completed
  @override
  Widget build(BuildContext context) {
    return Consumer<ElderProvider>(builder: (context, provider, child) {
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
        var currentTimeStamp = DateTime.now().millisecondsSinceEpoch - halfHour;
        var upcoming = provider.events.where((element) => element.timeStamp > (currentTimeStamp)).toList();
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Upcoming events",
                  style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600)),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ElderCalendarScreen()));
                  },
                  child: const Text("View All ▼",
                      style: TextStyle(fontSize: 12, color: MyTheme.primaryColor, fontWeight: FontWeight.w600))),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: upcoming.length,
                  itemBuilder: (_, index) => EventsWidgetWithMarkButton(
                        event: upcoming[index],
                        markAsCompleted: () {
                          provider.markEventAsCompleted(upcoming[index]);
                        },
                      )))
        ]);
      }
    });
  }
}

class HomeScreenTopSection extends StatelessWidget {
  const HomeScreenTopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome \nto Elderly Care! ',
                  style: TextStyle(fontSize: 20, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w800)),
              Consumer<AuthProvider>(builder: (context, provider, child) {
                return Text(provider.currentUser?.name ?? "-",
                    style: const TextStyle(fontSize: 16, color: MyTheme.accentColor, fontWeight: FontWeight.w500));
              }),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16),
          child: ThreeDotMenu(),
        )
      ],
    );
  }
}
