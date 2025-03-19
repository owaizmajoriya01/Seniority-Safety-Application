import 'package:elderly_care/models/my_events.dart';
import 'package:elderly_care/provider/caretaker_provider.dart';
import 'package:elderly_care/provider/elder_provider.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../../my_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with SingleTickerProviderStateMixin {
  //var list = List.generate(200, (index) => Pair(index % 5, "Element $index"));
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      appBar: const MyAppBar(
        title: "Calendar",
      ),
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)), // Creates border
                    color: MyTheme.secondaryColor),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 14, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w500),
                labelStyle: const TextStyle(fontSize: 14, color: MyTheme.white, fontWeight: FontWeight.w600),
                unselectedLabelColor: MyTheme.secondaryAccentColor,
                controller: _tabController,
                padding: const EdgeInsets.only(top: 16, bottom: 20),
                labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
                onTap: (int index) {},
                tabs: const [Text("UpComing"), Text("Past")]),
            Expanded(
              child: Consumer<CaretakerProvider>(builder: (context, provider, child) {
                var events = provider.events;
                var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
                var upcoming = <MyEvent>[];
                var past = <MyEvent>[];
                for (var element in events) {
                  if (element.timeStamp > currentTimeStamp) {
                    upcoming.add(element);
                  } else {
                    past.add(element);
                  }
                }

                return TabBarView(controller: _tabController, children: [
                  CalendarTabViewList(
                    list: upcoming,
                  ),
                  CalendarTabViewList(list: past),
                ]);
              }),
            ),
          ],
        ),
      )),
    );
  }
}

class CalendarTabViewList extends StatelessWidget {
  const CalendarTabViewList({Key? key, required this.list}) : super(key: key);
  final List<MyEvent> list;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          NoDataFound(message: "No Upcoming Event"),
        ],
      );
    } else {
      return GroupedListView<MyEvent, String>(
          elements: list,
          groupBy: (element) {
            return element.formattedDateTime;
          },
          itemBuilder: (context, element) => EventsWidget(event: element),
          groupHeaderBuilder: (element) => Text(
                element.formattedDateTime,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
          floatingHeader: true,
          useStickyGroupSeparators: true);
    }
  }
}

class EventsWidgetWithMarkButton extends StatelessWidget {
  const EventsWidgetWithMarkButton({Key? key, required this.event, required this.markAsCompleted}) : super(key: key);
  final MyEvent event;
  final VoidCallback markAsCompleted;

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
          children: [
            _EventIcons(eventType: EventType.intToEventType(event.eventType)),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    EventType.intToEventType(event.eventType).name,
                    style:
                        const TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                  ),
                  Text(event.note,
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w400)),
                  Text(event.formattedDateTime,
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                  Text(event.receiverName,
                      style: const TextStyle(fontSize: 10, color: MyTheme.accentColor, fontWeight: FontWeight.w500)),
                  _buildEventStatus(event.isCompleted),
                  Visibility(
                    visible: event.isCompleted == false,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: PrimaryButton(
                        onPressed: markAsCompleted,
                        text: "Mark Completed",
                        elevation: 1,
                        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                        leadingWidget: const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(8, 2, 12, 2),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEventStatus(bool status) {
    if (status) {
      return const Text("Event Completed",
          style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500));
    } else {
      return const Text("Event Pending",
          style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w500));
    }
  }
}

class EventsWidget extends StatelessWidget {
  const EventsWidget({Key? key, required this.event}) : super(key: key);
  final MyEvent event;

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
          children: [
            _EventIcons(eventType: EventType.intToEventType(event.eventType)),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    EventType.intToEventType(event.eventType).name,
                    style:
                        const TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                  ),
                  Text(event.note,
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w400)),
                  Text(event.formattedDateTime,
                      style: const TextStyle(fontSize: 12, color: MyTheme.mediumGray, fontWeight: FontWeight.w500)),
                  Text(event.receiverName,
                      style: const TextStyle(fontSize: 10, color: MyTheme.accentColor, fontWeight: FontWeight.w500)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EventIcons extends StatelessWidget {
  const _EventIcons({Key? key, required this.eventType}) : super(key: key);
  final EventType eventType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _bgColor, borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(6),
      child: _icon,
    );
  }

  Widget get _icon {
    IconData iconData;
    switch (eventType) {
      case EventType.appointment:
        iconData = FontAwesomeIcons.calendarDay;
        break;
      case EventType.pills:
        iconData = FontAwesomeIcons.pills;
        break;
      case EventType.tests:
        iconData = FontAwesomeIcons.vials;
        break;
      case EventType.reminder:
        iconData = FontAwesomeIcons.noteSticky;
        break;
      case EventType.visit:
        iconData = FontAwesomeIcons.personWalking;
        break;
    }
    return Icon(
      iconData,
      size: 20,
    );
  }

  Color get _bgColor {
    switch (eventType) {
      case EventType.appointment:
        return const Color(0xff88ecb3);
      case EventType.pills:
        return const Color(0xffecdb88);
      case EventType.tests:
        return const Color(0xff8899ec);
      case EventType.reminder:
        return const Color(0xffae88ec);
      case EventType.visit:
        return const Color(0xffec88c4);
    }
  }
}

enum MyIcons { appointments, pills, tests, others, time, date, user }

class IconsWithBackgroundColor extends StatelessWidget {
  const IconsWithBackgroundColor({Key? key, required this.iconType}) : super(key: key);
  final MyIcons iconType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(color: _bgColor, borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(6),
      child: _icon,
    );
  }

  Widget get _icon {
    IconData iconData;
    switch (iconType) {
      case MyIcons.appointments:
        iconData = FontAwesomeIcons.calendarDay;
        break;
      case MyIcons.pills:
        iconData = FontAwesomeIcons.pills;
        break;
      case MyIcons.tests:
        iconData = FontAwesomeIcons.vials;
        break;
      case MyIcons.others:
        iconData = FontAwesomeIcons.notesMedical;
        break;
      case MyIcons.time:
        iconData = FontAwesomeIcons.clock;
        break;
      case MyIcons.date:
        iconData = FontAwesomeIcons.calendar;
        break;
      case MyIcons.user:
        iconData = FontAwesomeIcons.user;
        break;
    }
    return Icon(
      iconData,
      size: 16,
    );
  }

  Color get _bgColor {
    switch (iconType) {
      case MyIcons.appointments:
        return const Color(0xff88ecb3);
      case MyIcons.pills:
        return const Color(0xffecdb88);
      case MyIcons.tests:
        return const Color(0xff8899ec);
      case MyIcons.others:
        return const Color(0xff95ec88);
      case MyIcons.time:
        return const Color(0xffecae88);
      case MyIcons.date:
        return const Color(0xffec88df);
      case MyIcons.user:
        return const Color(0xff88e4ec);
    }
  }
}

class ElderCalendarScreen extends StatefulWidget {
  const ElderCalendarScreen({Key? key}) : super(key: key);

  @override
  State<ElderCalendarScreen> createState() => _ElderCalendarScreenState();
}

class _ElderCalendarScreenState extends State<ElderCalendarScreen> with SingleTickerProviderStateMixin {
  //var list = List.generate(200, (index) => Pair(index % 5, "Element $index"));
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Calendar",
      ),
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)), // Creates border
                    color: MyTheme.secondaryColor),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 14, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w500),
                labelStyle: const TextStyle(fontSize: 14, color: MyTheme.white, fontWeight: FontWeight.w600),
                unselectedLabelColor: MyTheme.secondaryAccentColor,
                controller: _tabController,
                padding: const EdgeInsets.only(top: 16, bottom: 20),
                labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
                onTap: (int index) {},
                tabs: const [Text("UpComing"), Text("Past")]),
            Expanded(
              child: Consumer<ElderProvider>(builder: (context, provider, child) {
                var events = provider.events;
                var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
                var upcoming = <MyEvent>[];
                var past = <MyEvent>[];
                for (var element in events) {
                  if (element.timeStamp > currentTimeStamp) {
                    upcoming.add(element);
                  } else {
                    past.add(element);
                  }
                }

                return TabBarView(controller: _tabController, children: [
                  CalendarTabViewList(
                    list: upcoming,
                  ),
                  CalendarTabViewList(list: past),
                ]);
              }),
            ),
          ],
        ),
      )),
    );
  }
}
