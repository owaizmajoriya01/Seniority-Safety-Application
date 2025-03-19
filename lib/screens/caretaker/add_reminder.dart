import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/ripple_effect_widget.dart';
import 'package:elderly_care/widgets/textfield_v2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../models/my_events.dart';
import '../../models/my_user.dart';
import '../../my_theme.dart';
import '../../provider/caretaker_provider.dart';
import '../../utils/dialog.dart';
import '../../utils/shared_pref_helper.dart';
import '../../utils/validators.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/dropdown.dart';

class BottomSheetNameAndClose extends StatelessWidget {
  const BottomSheetNameAndClose({Key? key, required this.title, this.onCloseButtonPressed}) : super(key: key);
  final String title;
  final VoidCallback? onCloseButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Text(title,
            style: const TextStyle(fontSize: 20, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600)),
        MyRippleEffectWidget(
            onTap: onCloseButtonPressed ?? () => Navigator.pop(context), child: const Icon(Icons.clear_rounded))
      ],
    );
  }
}

class BottomSheetIndicator extends StatelessWidget {
  const BottomSheetIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
      ),
    );
  }
}

class AddReminder extends StatelessWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        title: "Add Reminder",
        centerTitle: true,
      ),
      body: _AddReminder(),
    );
  }
}

class _AddReminder extends StatefulWidget {
  const _AddReminder({Key? key}) : super(key: key);

  @override
  State<_AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<_AddReminder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController(),
      _time = TextEditingController(),
      _reminderText = TextEditingController();
  final _reminderTypes = EventType.values.map((e) => e.name).toList();

  EventType? _selectedReminderType;

  MyUser? _selectedUser;

  TimeOfDay? _timeOfDay;
  DateTime? _day;

  @override
  void dispose() {
    _date.dispose();
    _time.dispose();
    _reminderText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      var elder = provider.assignedUsers.firstWhereOrNull((element) => element.name == selectedValue);
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
                  title: "Reminder Type",
                  child: MyDropdownV2(
                    prefixIcon: const Icon(Icons.event),
                    items: _reminderTypes,
                    hintText: "Reminder type",
                    validator: (value) => MyValidator.defaultValidator(value, "Invalid reminder"),
                    onChanged: (value) {
                      if (value == null) return;
                      var type = EventType.nameToEventType(value);
                      _selectedReminderType = type;
                    },
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
                  ),
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
                          initialDate: currentTime, firstDate: currentTime, lastDate: DateTime(currentTime.year + 1)),
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
                    ),
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
                ),
              ),
              PrimaryButton.expanded(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _onCreateReminder();
                  }
                },
                text: "Add",
                margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateReminder() {
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
      eventType: EventType.eventTypeToInt(_selectedReminderType!),
      note: _reminderText.text,
      isCompleted: false,
      timeStamp: date.millisecondsSinceEpoch,
    );

    MyLoadingDialog.show(context, "Creating reminder...");
    context.read<CaretakerProvider>().createEvent(event, _selectedUser).then((value) {
      MyLoadingDialog.close(context);
      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "Reminder created Successfully",
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

class DateTimeBottomSheets {
  void showDatePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => const _DatePickerBottomSheet());
  }

  void showTimePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => const _TimePickerBottomSheet());
  }
}

class _DatePickerBottomSheet extends StatelessWidget {
  const _DatePickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
      onDateTimeChanged: (DateTime value) {},
    );
  }
}

class _TimePickerBottomSheet extends StatelessWidget {
  const _TimePickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimePickerDialog(
      initialTime: TimeOfDay.now(),
    );
  }
}
