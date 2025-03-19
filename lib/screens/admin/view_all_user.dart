import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/provider/admin_ui_state.dart';
import 'package:elderly_care/provider/caretaker_profile_provider.dart';
import 'package:elderly_care/screens/elder/view_caretaker_profile.dart';
import 'package:elderly_care/widgets/dialogs.dart';
import 'package:elderly_care/widgets/image_widget.dart';
import 'package:elderly_care/widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my_theme.dart';
import '../../widgets/buttons.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({Key? key}) : super(key: key);

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Users",
                  style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w800)),
              TabBar(
                  indicator: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      // Creates border
                      color: MyTheme.secondaryColor),
                  unselectedLabelStyle:
                      const TextStyle(fontSize: 14, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w500),
                  labelStyle: const TextStyle(fontSize: 14, color: MyTheme.white, fontWeight: FontWeight.w600),
                  unselectedLabelColor: MyTheme.secondaryAccentColor,
                  controller: _tabController,
                  padding: const EdgeInsets.only(top: 16, bottom: 20),
                  labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
                  onTap: (int index) {},
                  tabs: const [Text("Elders"), Text("Caretakers")]),
              Expanded(
                child: Consumer<AdminUiState>(builder: (context, provider, child) {
                  return TabBarView(controller: _tabController, children: [
                    _MyListView(users: provider.elderList, isCaretaker: false),
                    _MyListView(users: provider.caretakerList, isCaretaker: true),
                  ]);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyListView extends StatelessWidget {
  const _MyListView({Key? key, required this.users, required this.isCaretaker}) : super(key: key);
  final List<MyUser> users;
  final bool isCaretaker;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (users.isEmpty) {
      child = const NoDataFound(
        message: "No Users found",
      );
    } else {
      child = ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => UserItem(user: users[index], isCaretaker: isCaretaker));
    }
    return RefreshIndicator(
        onRefresh: () {
          debugPrint('Debug _AllUserScreenState.build : ');
          return context.read<AdminUiState>().refreshUser();
        },
        child: child);
  }
}

class UserItem extends StatelessWidget {
  const UserItem({Key? key, required this.user, required this.isCaretaker}) : super(key: key);
  final MyUser user;
  final bool isCaretaker;

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
            ImageOrIconWidget(
              imageUrl: user.imageUrl,
              size: const Size.square(24),
              borderRadius: 6,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.name} (${user.calculateAge})",
                    style:
                        const TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                  ),
                  Text(user.mobile ?? "-",
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                  Text(user.email ?? "-",
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                  _buildAccountStatus(user.isEnabled == true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildEnableDisableButton(user.isEnabled == true, context),
                      MyIconButton(
                        onTap: () {
                          Widget route;
                          if (isCaretaker) {
                            route = const ViewCaretakerProfileScreen();
                          } else {
                            route = const ViewElderProfileScreen();
                          }

                          context.read<ProfileProvider>().setUser(user);

                          Navigator.push(context, MaterialPageRoute(builder: (_) => route));
                        },

                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 16,
                        ),
                        //padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      ),
                      const SizedBox(width: 16),
                      MyIconButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => InfoDialog(
                                    header: "Delete User",
                                    message: "Are you sure you ant to delete this user?",
                                    onPositiveTap: () {
                                      Navigator.pop(_);
                                      _deleteUser(context);
                                    },
                                    onNegativeTap: () {
                                      Navigator.pop(_);
                                    },
                                  ));
                        },

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                        color: Colors.redAccent,
                        // padding: const EdgeInsets.fromLTRB(8, 2, 12, 2),
                      ),
                      const SizedBox(width: 16),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEnableDisableButton(bool status, BuildContext context) {
    if (status) {
      return PrimaryButton(
        onPressed: () {
          context.read<AdminUiState>().disableAccount(user);
        },
        text: "Disable",
        elevation: 1,
        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
        enableColor: Colors.red,
        leadingWidget: const Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(
            Icons.disabled_by_default,
            color: Colors.white,
            size: 16,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(8, 2, 12, 2),
      );
    } else {
      return PrimaryButton(
        onPressed: () {
          context.read<AdminUiState>().enableAccount(user);
        },
        text: "Enable",
        elevation: 1,
        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
        enableColor: Colors.green,
        leadingWidget: const Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(
            Icons.check_box,
            color: Colors.white,
            size: 16,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(8, 2, 12, 2),
      );
    }
  }

  Widget _buildAccountStatus(bool status) {
    if (status) {
      return const Text("Account Enabled",
          style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500));
    } else {
      return const Text("Account Disabled",
          style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w500));
    }
  }

  void _deleteUser(BuildContext context) {
    context.read<AdminUiState>().deleteUser(user, isCaretaker).then((value) {
      if (value.success == false) {
        showDialog(
            context: context,
            builder: (_) => ErrorDialog(
                  message: value.errorMessage,
                ));
      } else {
        showDialog(
            context: context,
            builder: (_) => const SuccessDialog(
                  message: "User deleted successfully",
                ));
      }
    });
  }
}
