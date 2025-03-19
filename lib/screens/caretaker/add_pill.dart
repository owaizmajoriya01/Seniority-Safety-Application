import 'package:elderly_care/models/my_events.dart';
import 'package:elderly_care/provider/caretaker_provider.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:elderly_care/utils/validators.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../models/my_user.dart';
import '../../utils/dialog.dart';
import '../../widgets/buttons.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/textfield_v2.dart';

class AddPillReminderScreen extends StatefulWidget {
  const AddPillReminderScreen({Key? key}) : super(key: key);

  @override
  State<AddPillReminderScreen> createState() => AddPillReminderScreenState();
}

class AddPillReminderScreenState extends State<AddPillReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController(),
      _time = TextEditingController(),
      _pillName = TextEditingController(),
      _reminderText = TextEditingController();

  MyUser? _selectedUser;

  TimeOfDay? _timeOfDay;
  DateTime? _day;

  @override
  void dispose() {
    _pillName.dispose();
    _date.dispose();
    _time.dispose();
    _reminderText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Add Pill",
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TitleWrapper(
                    title: "Elder Name",
                    child: Consumer<CaretakerProvider>(builder: (context, provider, child) {
                      return MyDropdownV2(
                        items: provider.assignedUsers.map((e) => e.name ?? "-").toList(),
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Name of the Elder",
                        onChanged: (selectedValue) {
                          var elder =
                              provider.assignedUsers.firstWhereOrNull((element) => element.name == selectedValue);
                          if (elder != null) {
                            _selectedUser = elder;
                          }
                        },
                        validator: (value) => MyValidator.defaultValidator(value),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TitleWrapper(
                      title: "Pill Name",
                      child: MyTextFieldV2(
                        prefix: const Icon(FontAwesomeIcons.pills),
                        hintText: "Name of the pill",
                        validator: (value) => MyValidator.defaultValidator(value, "Invalid pill name"),
                        controller: _pillName,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? time = await showDialog(
                          context: context,
                          builder: (_) => TimePickerDialog(
                                initialTime: TimeOfDay.now(),
                              ));
                      if (time != null) {
                        _timeOfDay = time;
                        _time.text = time.format(context);
                      }
                    },
                    child: TitleWrapper(
                      title: "Time",
                      child: MyTextFieldV2(
                          prefix: const Icon(Icons.access_time_filled),
                          hintText: "Reminder time",
                          controller: _time,
                          isReadOnly: true,
                          validator: (value) => MyValidator.defaultValidator(value, "Invalid time")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        var currentTime = DateTime.now();
                        DateTime? date = await showDialog(
                          context: context,
                          builder: (_) => DatePickerDialog(
                              initialDate: currentTime,
                              firstDate: currentTime,
                              lastDate: DateTime(currentTime.year + 1)),
                        );
                        if (date != null) {
                          _day = date;
                          DateFormat df = DateFormat("yyyy-MM-dd");
                          _date.text = df.format(date);
                        }
                      },
                      child: TitleWrapper(
                        title: "Date",
                        child: MyTextFieldV2(
                            prefix: const Icon(Icons.calendar_month),
                            hintText: "Reminder date",
                            controller: _date,
                            isReadOnly: true,
                            validator: (value) => MyValidator.defaultValidator(value, "Invalid date")),
                      ),
                    ),
                  ),
                  TitleWrapper(
                    title: "Note",
                    child: MyTextFieldV2(
                        prefix: const Icon(Icons.edit_note_rounded),
                        hintText: "Additional Notes about reminder",
                        controller: _reminderText,
                        minLines: 3,
                        validator: (value) => MyValidator.defaultValidator(
                              value,
                            )),
                  ),
                  PrimaryButton.expanded(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _onCreatePillReminder();
                      }
                    },
                    text: "Add",
                    margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCreatePillReminder() {
    if (_day == null || _timeOfDay == null) return;
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    String name = AppPreferenceUtil.getString(SharedPreferencesKey.userName);
    var date = _day!.add(Duration(hours: _timeOfDay!.hour, minutes: _timeOfDay!.minute));
    final event = MyEvent(
      uid: "",
      senderUid: uid,
      senderName: name,
      receiverUid: _selectedUser!.uid!,
      receiverName: _selectedUser!.name!,
      eventType: EventType.eventTypeToInt(EventType.pills),
      note: _reminderText.text,
      isCompleted: false,
      timeStamp: date.millisecondsSinceEpoch,
      name: _pillName.text,
    );

    MyLoadingDialog.show(context, "Creating reminder...");
    context.read<CaretakerProvider>().createEvent(event,_selectedUser).then((value) {
      MyLoadingDialog.close(context);
      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "Pill Reminder created Successfully",
                  onNeutralTap: () {
                    Navigator.pop(_);
                    Navigator.pop(context);
                  },
                ));
      } else {
        showDialog(
            context: context,
            builder: (_) => ErrorDialog(
                  message: value.errorMessage,
                ));
      }
    });
  }
}
