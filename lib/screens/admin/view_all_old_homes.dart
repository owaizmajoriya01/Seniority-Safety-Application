import 'package:elderly_care/models/old_age_home.dart';
import 'package:elderly_care/provider/admin_ui_state.dart';
import 'package:elderly_care/screens/admin/create_old_age_home_screen.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/image_widget.dart';

class ViewAllOldAgeHomesScreen extends StatelessWidget {
  const ViewAllOldAgeHomesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Old Age Homes"),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AdminUiState>(
            builder: (context, provider, child) {
              return ListView.builder(
                  itemCount: provider.oldAgeHomeList.length,
                  itemBuilder: (_, index) => _OldAgeHomeItem(home: provider.oldAgeHomeList[index]));
            },
          ),
        ),
      ),
    );
  }
}

class _OldAgeHomeItem extends StatelessWidget {
  const _OldAgeHomeItem({Key? key, required this.home}) : super(key: key);
  final OldAgeHome home;

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
              icon: Icon(Icons.home_filled),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    home.name,
                    style:
                        const TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                  ),
                  Text(home.contactNumber,
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                  Text(home.email,
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            MyIconButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreateOldAgeHomeScreen(
                                home: home,
                              )));
                },
                icon: const Icon(Icons.edit))
          ],
        ),
      ),
    );
  }
}
