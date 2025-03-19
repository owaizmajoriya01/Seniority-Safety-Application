import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/my_events.dart';

import '../models/api_response.dart';
import '../utils/db_collections.dart';

class EventsRepository {
  Future<ApiResponse> addEvent(MyEvent event) async {
    try {
      var id = FirebaseFirestore.instance.collection(CollectionNames.events).doc().id;
      var updatedEvent = event.copyWith(uid: id);
      await FirebaseFirestore.instance.collection(CollectionNames.events).doc(id).set(updatedEvent.toMap());
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse> markEventAsComplete(MyEvent event) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.events).doc(event.uid).set(
          event.copyWith(isCompleted: true, completedTimeStamp: DateTime.now().millisecondsSinceEpoch).toMap(),
          SetOptions(merge: true));
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyEvent>>> getAllEvent() async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.events).get();
      List<MyEvent> result = response.docs.map((e) => MyEvent.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyEvent>>> getAllEventBySenderId(String senderId) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.events)
          .where("senderUid", isEqualTo: senderId)
          .get();
      List<MyEvent> result = response.docs.map((e) => MyEvent.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyEvent>>> getAllEventByReceiverId(String receiverId) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.events)
          .where("receiverUid", isEqualTo: receiverId)
          .get();
      List<MyEvent> result = response.docs.map((e) => MyEvent.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<Stream<QuerySnapshot<Map<String, dynamic>>>?>> getAllEventStreamByReceiverId(
      String receiverId) async {
    try {
      var response = FirebaseFirestore.instance
          .collection(CollectionNames.events)
          .where("receiverUid", isEqualTo: receiverId)
          .snapshots();
      return ApiResponse(success: true, data: response, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }
}
