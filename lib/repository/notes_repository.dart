import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/my_audio_notes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

import '../models/api_response.dart';
import '../utils/db_collections.dart';

class NotesRepository {
  Future<ApiResponse<bool>> uploadNote(MyAudioNotes note) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.audioNotes).add(note.toMap());
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<String?>> uploadNoteFile(File file, String senderUid) async {
    try {
      final imageFileName = senderUid + DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child(imageFileName);
      final uploadTask = await imageRef.putFile(file);

      if (uploadTask.state == TaskState.success) {
        final url = await imageRef.getDownloadURL();
        return ApiResponse(success: true, data: url, statusCode: 200);
      }
      return const ApiResponse(success: false, data: null, errorMessage: null);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<MyAudioNotes?>> uploadNoteWithFile(MyAudioNotes note, File file) async {
    var fileUploadResponse = await uploadNoteFile(file, note.to);

    if (fileUploadResponse.success && fileUploadResponse.data != null) {
      var updatedNote = note.copyWith(url: fileUploadResponse.data);
      await uploadNote(updatedNote);
      return ApiResponse(success: true, data: updatedNote);
    } else {
      return ApiResponse(
          success: false, data: null, errorMessage: fileUploadResponse.errorMessage ?? "Something went wrong");
    }
  }

  Future<ApiResponse<List<MyAudioNotes>>> getNotesBySenderUid(String uid) async {
    try {
      var response =
          await FirebaseFirestore.instance.collection(CollectionNames.audioNotes).where("from", isEqualTo: uid).get();
      debugPrint('Debug NotesRepository.getNotesBySenderUid : $uid');
      debugPrint('Debug NotesRepository.getNotesBySenderUid : ${response}');
      debugPrint('Debug NotesRepository.getNotesBySenderUid : ${response.docs.map((e) => e.data())}');
      List<MyAudioNotes> result = response.docs.map((e) => MyAudioNotes.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyAudioNotes>>> getNotesByReceiverUid(String uid) async {
    try {
      var response =
          await FirebaseFirestore.instance.collection(CollectionNames.audioNotes).where("to", isEqualTo: uid).get();
      List<MyAudioNotes> result = response.docs.map((e) => MyAudioNotes.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<Stream<QuerySnapshot<Map<String, dynamic>>>?>> getNotesStreamByReceiverUid(String uid) async {
    try {
      var response =
          FirebaseFirestore.instance.collection(CollectionNames.audioNotes).where("to", isEqualTo: uid).snapshots();

      return ApiResponse(success: true, data: response, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }
}
