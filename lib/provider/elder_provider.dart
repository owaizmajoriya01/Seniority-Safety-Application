import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/models/my_events.dart';
import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/repository/assigned_repository.dart';
import 'package:elderly_care/repository/events_repository.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';


class ElderProvider with ChangeNotifier {
  final _assignedCaretaker = <MyUser>[];
  final _events = <MyEvent>[];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listener;

  List<MyUser> get assignedCaretakers => UnmodifiableListView(_assignedCaretaker);

  List<MyEvent> get events => UnmodifiableListView(_events);

  ElderProvider() {
    init();
  }

  init() {
    Future.wait([_getAssignedCaretakers(), _fetchEventsByElder()]).then((value) {
      //_addDummyData();
      notifyListeners();
    });
    _fetchEventsByElderStream();
  }


  Future<void> _getAssignedCaretakers() async {
    var uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);

    var elders = await AssignedRepository().getCareTakersAssignedTo(uid);

    if (elders.success && elders.data.isNotEmpty) {
      _assignedCaretaker.addAll(elders.data);
    }
  }

  Future<ApiResponse> createEvent(MyEvent event) async {
    return await EventsRepository().addEvent(event);
  }

  Future<void> _fetchEventsByElder() async {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var events = await EventsRepository().getAllEventByReceiverId(uid);
    if (events.success && events.data.isNotEmpty) {
      _events.clear();
      _events.addAll(events.data);
    }
  }

  Future<void> _fetchEventsByElderStream() async {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var response = await EventsRepository().getAllEventStreamByReceiverId(uid);
    if (response.success && response.data != null) {
      _listener = response.data!.listen((events) {
        List<MyEvent> list = [];
        for (var event in events.docs) {
          list.add(MyEvent.fromMap(event.data()));
        }
        _events.clear();
        _events.addAll(list);
        notifyListeners();
      });
    }
  }

  void _closeEventStream() {
    if (_listener != null) {
      _listener!.cancel();
    }
  }

  Future<void> refreshEvents() async {
    await _fetchEventsByElder();
    notifyListeners();
  }

  @override
  void dispose() {
    _closeEventStream();
    super.dispose();
  }

  Future<ApiResponse> markEventAsCompleted(MyEvent event) async {
    var response  = await EventsRepository().markEventAsComplete(event);
    if(response.success){
      var index = _events.indexWhere((element) => element.uid == event.uid);
      if(index!=-1){
        _events[index] = event;
        notifyListeners();
      }
    }
    return response;
  }
}
