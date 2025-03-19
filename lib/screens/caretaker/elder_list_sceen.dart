import 'package:elderly_care/provider/caretaker_provider.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/my_user.dart';
import '../../my_theme.dart';
import '../../utils/url_launcher_utils.dart';
import '../../widgets/buttons.dart';
import '../../widgets/image_widget.dart';
import '../../widgets/no_data_found_widget.dart';
import 'location_screen.dart';

class ElderListScreen extends StatelessWidget {
  const ElderListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Assigned elders",
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<CaretakerProvider>(
            builder: (context, provider, child) {
              if (provider.assignedUsers.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: NoDataFound(
                        message: "No Elders assigned.\nPlease Contact Admin.",
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                    itemCount: provider.assignedUsers.length,
                    itemBuilder: (_, index) => UserItemWithButtons(user: provider.assignedUsers[index]));
              }
            },
          ),
        ),
      ),
    );
  }
}

class UserItemWithButtons extends StatelessWidget {
  const UserItemWithButtons({Key? key, this.user,this.showLocateButton = true}) : super(key: key);

  final MyUser? user;
  final bool showLocateButton;



  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ImageOrIconWidget(
                size: Size.square(24),
                borderRadius: 6,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user!.name} (${user!.calculateAge})",
                      style: const TextStyle(
                          fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                    ),
                    Text(user!.mobile ?? "-",
                        style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                    Text(user!.email ?? "-",
                        style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: showLocateButton,
                          child: MyIconButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DistanceScreen(
                                              user: user,
                                            )));
                              },
                              icon: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(width: 16),
                        Visibility(
                          visible: user?.mobile?.isNotEmpty == true,
                          child: MyIconButton(
                            onTap: () {
                              if (user?.mobile != null && user?.mobile?.isNotEmpty == true) {
                                UrlLauncherUtil().call(user!.mobile!);
                              }
                            },
                            icon: const Icon(Icons.call, color: Colors.white),
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
