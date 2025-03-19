import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/dropdown.dart';
import 'package:elderly_care/widgets/textfield_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/buttons.dart';

class SendDonationScreen extends StatefulWidget {
  const SendDonationScreen({Key? key}) : super(key: key);

  @override
  State<SendDonationScreen> createState() => _SendDonationScreenState();
}

class _SendDonationScreenState extends State<SendDonationScreen> {
  final TextEditingController _amount = TextEditingController(), _additionalText = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _additionalText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Send Donation",centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              const TitleWrapper(
                title: "Old Age Name",
                child: MyDropdownV2(
                  items: ["Test", "Test2"],
                  prefixIcon: Icon(Icons.person),
                  hintText: "Old age Name",
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TitleWrapper(
                    title: 'Amount',
                    child: MyTextFieldV2(

                      prefix: const Icon(Icons.attach_money_rounded),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  )),
              TitleWrapper(
                title: "Note",
                child: MyTextFieldV2(
                  prefix: const Icon(Icons.edit_note_rounded),
                  hintText: "Additional Note",
                  controller: _additionalText,
                  minLines: 3,
                ),
              ),
              PrimaryButton.expanded(
                onPressed: () {},
                text: "Send",
                margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
