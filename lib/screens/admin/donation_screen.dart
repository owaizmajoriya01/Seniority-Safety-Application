import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/donation.dart';
import '../../my_theme.dart';
import '../../provider/admin_ui_state.dart';
import '../../utils/date_utils.dart';
import '../../widgets/appbar.dart';
import '../../widgets/image_widget.dart';

class DonationListScreen extends StatelessWidget {
  const DonationListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Donations"),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AdminUiState>(
            builder: (context, provider, child) {
              return ListView.builder(
                  itemCount: provider.donationList.length,
                  itemBuilder: (_, index) => _DonationItem(donation: provider.donationList[index]));
            },
          ),
        ),
      ),
    );
  }
}

class _DonationItem extends StatelessWidget {
  const _DonationItem({Key? key, required this.donation}) : super(key: key);
  final Donation donation;

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
              icon: Icon(Icons.monetization_on),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.senderName ?? "-",
                    style:
                        const TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                  ),
                  Text(donation.receiverName ?? "-",
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                  Text(MyDateUtils.parseTimeStamp(donation.timeStamp ?? 0),
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Text(
              "₹ ${donation.amount}",
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
