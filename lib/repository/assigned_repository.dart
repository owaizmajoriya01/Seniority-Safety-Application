import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/api_response.dart';
import '../models/assigned.dart';
import '../models/my_user.dart';
import '../utils/db_collections.dart';

class AssignedRepository {
  Future<ApiResponse<bool>> addAssigned(Assigned assigned) async {
    try {
      var ref = FirebaseFirestore.instance.collection(CollectionNames.assigned).doc();

      await FirebaseFirestore.instance.collection(CollectionNames.assigned).doc(ref.id).set(assigned.toMap());
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    } catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "Something went wrong $e");
    }
  }

  Future<ApiResponse<bool>> deleteAssigned(Assigned assigned) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.assigned).doc(assigned.uid).delete();
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    } catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "Something went wrong $e");
    }
  }

  Future<ApiResponse<List<MyUser>>> getCareTakersAssignedTo(String uid) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionNames.assigned)
          .where("elderUid", isEqualTo: uid)
          .get();
      List<Assigned> result = response.docs.map((e) => Assigned.fromMap(e.data())).toList();
      var users = await getUsers(getUniqueCareTakerUid(result));
      return users;
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyUser>>> getEldersAssignedTo(String uid) async {
    try {
      var response =
          await FirebaseFirestore.instance.collection(CollectionNames.assigned).where("careTakerUid", isEqualTo: uid).get();
      debugPrint('Debug AssignedRepository.getEldersAssignedTo : $uid ');
      debugPrint('Debug AssignedRepository.getEldersAssignedTo : ${response.docs} ');
      debugPrint('Debug AssignedRepository.getEldersAssignedTo : ${response.docs.first.data()} ');
      List<Assigned> result = response.docs.map((e) => Assigned.fromMap(e.data())).toList();
      //var users = await getUsers(getUniqueCareTakerUid(result));
      var users = await getUsers(result.map((e) => e.elderUid).toList());
      return users;
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<MyUser>>> getUsers(List<String> uid) async {
    try {
      var response =
          await FirebaseFirestore.instance.collection(CollectionNames.users).where("uid", whereIn: uid).get();
      List<MyUser> result = response.docs.map((e) => MyUser.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  List<Assigned> getUniqueAssigned(List<Assigned> assigned) {
    var seen = <String>{};
    List<Assigned> uniqueList = assigned.where((a) => seen.add(a.careTakerUid)).toList();
    return uniqueList;
  }

  List<String> getUniqueCareTakerUid(List<Assigned> assigned) {
    var uniqueUid = <String>{};
    for (var a in assigned) {
      uniqueUid.add(a.careTakerUid);
    }

    return uniqueUid.toList();
  }
}
