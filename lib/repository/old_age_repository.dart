import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/api_response.dart';
import '../models/old_age_home.dart';
import '../utils/db_collections.dart';

class OldAgeHomeRepository {
  Future<ApiResponse<OldAgeHome?>> addHome(OldAgeHome home) async {
    try {
      var ref = FirebaseFirestore.instance.collection(CollectionNames.oldAgeHomes).doc();
      final updatedHome = home.copyWith(uid: ref.id);
      await FirebaseFirestore.instance.collection(CollectionNames.oldAgeHomes).doc(ref.id).set(updatedHome.toMap());
      return ApiResponse(success: true, data: updatedHome, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: home, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<OldAgeHome>>> getAllHome() async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.oldAgeHomes).get();
      List<OldAgeHome> result = response.docs.map((e) {
        debugPrint('Debug OldAgeHomeRepository.getAllHome : ${e.data()}');
        return OldAgeHome.fromMap(e.data());
      }).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse> updateHome(OldAgeHome home) async {
    try {
      await FirebaseFirestore.instance
          .collection(CollectionNames.oldAgeHomes)
          .doc(home.uid)
          .set(home.toMap(), SetOptions(merge: true));
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }
}
