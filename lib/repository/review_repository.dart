import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/api_response.dart';
import '../models/my_review.dart';
import '../utils/db_collections.dart';

class ReviewRepository {
  Future<ApiResponse<bool>> addReview(MyReview review) async {
    try {
      await FirebaseFirestore.instance
          .collection(CollectionNames.reviews)
          .add(review.toMap());
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(
          success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyReview>>> getAllReview() async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.reviews)
          .get();
      List<MyReview> result =
          response.docs.map((e) => MyReview.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(
          success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyReview>>> getAllReviewBySenderId(
      String senderId) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.reviews)
          .where("senderUid", isEqualTo: senderId)
          .get();
      List<MyReview> result =
          response.docs.map((e) => MyReview.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(
          success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyReview>>> getAllReviewByReceiverId(
      String receiverId) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.reviews)
          .where("receiverUid", isEqualTo: receiverId)
          .get();
      List<MyReview> result =
          response.docs.map((e) => MyReview.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(
          success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }
}
