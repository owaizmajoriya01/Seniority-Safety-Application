import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/repository/notes_repository.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/my_audio_notes.dart';

class AudioNoteProvider with ChangeNotifier {
  final List<MyAudioNotes> _receivedAudioNotes = [];
  final List<MyAudioNotes> _sentAudioNotes = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listener;

  List<MyAudioNotes> get receivedAudioNotes => UnmodifiableListView(_receivedAudioNotes);

  List<MyAudioNotes> get sentAudioNotes => UnmodifiableListView(_sentAudioNotes);

  AudioNoteProvider() {
    init();
  }

  init() {
    Future.wait([_fetchReceivedAudioNotes(), _fetchSentAudioNotes()]).whenComplete(() {
      notifyListeners();
    });
    _streamReceivedAudioNotes();
  }

  Future<ApiResponse<MyAudioNotes?>> createAudioNote(MyAudioNotes note, String? filePath) async {
    if (filePath == null) {
      return const ApiResponse(success: false, data: null, errorMessage: "Invalid file.");
    }
    if (note.from.isEmpty) {
      String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
      note = note.copyWith(from: uid);
    }

    var response = await NotesRepository().uploadNoteWithFile(note, File(filePath));
    if (response.success && response.data != null) {
      _sentAudioNotes.add(response.data!);
      notifyListeners();
    }

    return response;
  }

  Future<void> _fetchReceivedAudioNotes() async {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var response = await NotesRepository().getNotesByReceiverUid(uid);
    if (response.success && response.data.isNotEmpty) {
      _receivedAudioNotes.addAll(response.data);
    }
  }

  Future<void> _fetchSentAudioNotes() async {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var response = await NotesRepository().getNotesBySenderUid(uid);
    if (response.success && response.data.isNotEmpty) {
      _sentAudioNotes.addAll(response.data);
    }
  }

  Future<void> _streamReceivedAudioNotes() async {
    String uid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var response = await NotesRepository().getNotesStreamByReceiverUid(uid);
    if (response.success && response.data != null) {
      _listener = response.data!.listen((events) {
        List<MyAudioNotes> list = [];
        for (var event in events.docs) {
          list.add(MyAudioNotes.fromMap(event.data()));
        }
        _receivedAudioNotes.clear();
        _receivedAudioNotes.addAll(list);
        notifyListeners();
      });
    }
  }

  void _closeAudioNoteStream() {
    if (_listener != null) {
      _listener!.cancel();
    }
  }

  Future<void> refresh() async {
    _sentAudioNotes.clear();
    _receivedAudioNotes.clear();
    init();
  }

  @override
  void dispose() {
    _closeAudioNoteStream();
    super.dispose();
  }
}
