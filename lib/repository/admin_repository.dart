import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/my_user.dart';

import '../models/api_response.dart';
import '../utils/db_collections.dart';

class AdminRepository {
  Future<ApiResponse<List<MyUser>>> getAllUsers() async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.users).get();
      List<MyUser> result = response.docs.map((e) => MyUser.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse> disableAccount(String uid) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.users).doc(uid).update({"isEnabled": false});
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: true, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse> enableAccount(String uid) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.users).doc(uid).update({"isEnabled": true});
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: true, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<bool>> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.users).doc(uid).delete();

      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: true, errorMessage: "${e.code} ${e.message}");
    }
  }
}
