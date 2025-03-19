import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/models/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/db_collections.dart';

class NotificationRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void setUpFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<ApiResponse> sendNotification(MyNotification notification, String? token) async {
    try {
      var id = FirebaseFirestore.instance.collection(CollectionNames.notifications).doc().id;
      var updatedNotification = notification.copyWith(uid: id);

      await FirebaseFirestore.instance.collection(CollectionNames.notifications).doc(id).set(updatedNotification.toMap());
      if (token != null) {
        await _sendNotification(SendNotificationData.fromMyNotification(updatedNotification, token));
      }
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse> sendNotificationWithoutToken(MyNotification notification) async {
    try {
      var id = FirebaseFirestore.instance.collection('_').doc().id;
      var updatedNotification =  notification.copyWith(uid: id);

      await FirebaseFirestore.instance.collection(CollectionNames.notifications).add(updatedNotification.toMap());
      if (updatedNotification.from != null) {
        var token = await getToken(updatedNotification.from!);
        if (token.data != null) {
          await _sendNotification(SendNotificationData.fromMyNotification(updatedNotification, token));
        }
      }

      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<void> _sendNotification(SendNotificationData notification) async {
    await _firebaseMessaging.sendMessage(
      to: notification.to,
      data: notification.toNotificationData(),
    );
  }

  Future<ApiResponse<List<MyNotification>>> getAllNotifications() async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.notifications).get();
      List<MyNotification> result = response.docs.map((e) => MyNotification.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<String?>> getToken(String uid) async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.deviceTokens).doc(uid).get();
      return ApiResponse(success: response.data() != null, data: response.data()?["token"], statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyNotification>>> getNotificationBySenderUid(String uid) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.notifications)
          .where("from", isEqualTo: uid)
          .get();
      List<MyNotification> result = response.docs.map((e) => MyNotification.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyNotification>>> getNotificationByReceiverUid(String uid) async {
    try {
      var response =
          await FirebaseFirestore.instance.collection(CollectionNames.notifications).where("to", isEqualTo: uid).get();
      List<MyNotification> result = response.docs.map((e) => MyNotification.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }
}
