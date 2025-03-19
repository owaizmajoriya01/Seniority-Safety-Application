import 'package:elderly_care/provider/admin_ui_state.dart';
import 'package:elderly_care/screens/admin/create_user.dart';
import 'package:elderly_care/utils/dialog.dart';
import 'package:elderly_care/utils/in_app_notification.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/in_app_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../my_theme.dart';
import '../../widgets/ripple_effect_widget.dart';
import '../elder/elder_home_screen.dart';
import 'create_old_age_home_screen.dart';
import 'donation_screen.dart';
import 'view_all_old_homes.dart';
import 'view_all_user.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeScreenTopSection(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 16),
                child: Row(
                  children: [
                    IconButtonWithText(
                      title: "+ Add\n Caretaker ",
                      icon: SvgPicture.asset("assets/svgs/add_user.svg"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserScreen()));
                      },
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: IconButtonWithText(
                        title: "+ Add\nElderly ",
                        icon: SvgPicture.asset("assets/svgs/add_user.svg"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddElderScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 16),
                child: Row(
                  children: [
                    IconButtonWithText(
                      title: "+ Add\nOld Age\nHomes ",
                      icon: SvgPicture.asset("assets/svgs/old_age_home.svg"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOldAgeHomeScreen()));
                      },
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: IconButtonWithText(
                        title: "+ View\nUsers ",
                        icon: SvgPicture.asset("assets/svgs/view_all.svg"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AllUserScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 16),
                child: Row(
                  children: [
                    IconButtonWithText(
                      title: "+ View\nOld Age\nHomes ",
                      icon: SvgPicture.asset("assets/svgs/old_age_home.svg"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewAllOldAgeHomesScreen()));
                      },
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: IconButtonWithText(
                        title: "+ View All\nDonations",
                        icon: SvgPicture.asset("assets/svgs/gift_svg.svg"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const DonationListScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton.expanded(
                  onPressed: () {
                    MyLoadingDialog.show(context, "Creating Dummy caretaker Account");
                    context.read<AdminUiState>().createUserWithFakeData().then((value) {
                      MyLoadingDialog.close(context);
                      if (value.success) {
                        InAppNotification.show(context,
                            title: "Success",
                            subtitle: "Created new caretaker with dummy data",
                            notificationType: NotificationType.info);
                      }
                    });
                  },
                  margin: EdgeInsets.zero,
                  text: "Create Dummy caretaker"),
              PrimaryButton.expanded(
                  margin: const EdgeInsets.only(top: 12),
                  onPressed: () {
                    MyLoadingDialog.show(context, "Creating Dummy Elder Account");
                    context.read<AdminUiState>().createElderWithFakeData().then((value) {
                      MyLoadingDialog.close(context);
                      if (value.success) {
                        InAppNotification.show(context,
                            title: "Success",
                            subtitle: "Created new Elder with dummy data",
                            notificationType: NotificationType.info);
                      }
                    });
                  },
                  text: "Create Dummy Elder")
            ],
          ),
        ),
      )),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  const IconButtonWithText({Key? key, required this.icon, required this.title, this.onTap}) : super(key: key);
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(6),
      child: MyRippleEffectWidget(
        onTap: onTap,
        child: SizedBox(
          height: 100,
          width: size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: size.width * 0.25,
                  child: icon,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
