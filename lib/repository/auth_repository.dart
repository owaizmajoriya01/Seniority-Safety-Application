import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/utils/db_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import '../models/my_user.dart';
import '../utils/shared_pref_helper.dart';

class AuthRepository {
  Future<ApiResponse<UserCredential?>> loginWithEmailPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user?.uid != null) {
        final userResponse = await getUserById(credential.user!.uid);
        if (userResponse.success && userResponse.data != null) {
          _saveLoginData(userResponse.data!);
        }
      }
      return ApiResponse(success: true, data: credential, statusCode: 200);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "Wrong password provided for that user.");
      }
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    } catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _clearUserData();
    } on FirebaseAuthException catch (_) {}
  }

  Future<ApiResponse<UserCredential?>> createUserWithEmailPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return ApiResponse(success: true, data: credential, statusCode: 200);
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthRepository.createUserWithEmailPassword : ${e.code} ");
      if (e.code == 'user-not-found') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "Wrong password provided for that user.");
      }
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<MyUser?>> createUserInDb(String uid, MyUser user) async {
    try {
      final updatedUser = user.copyWith(uid: uid);
      await FirebaseFirestore.instance
          .collection(CollectionNames.users)
          .doc(uid)
          .set(updatedUser.toMap(), SetOptions(merge: true));
      //.onError((error, stackTrace) => ApiResponse(success: false, data: null, errorMessage: error.toString()));
      return ApiResponse(success: true, data: updatedUser, statusCode: 200);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "Wrong password provided for that user.");
      }
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<void>> updateToken(String uid, String deviceToken) async {
    try {
      final data = {"deviceToken": deviceToken};

      await FirebaseFirestore.instance
          .collection(CollectionNames.users)
          .doc(uid)
          .set(data, SetOptions(merge: true));
      //.onError((error, stackTrace) => ApiResponse(success: false, data: null, errorMessage: error.toString()));
      return const ApiResponse(success: true, data: null, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<void>> updateLatLong(String uid, Position position) async {
    if (uid.isEmpty) return const ApiResponse(success: false, data: null, errorMessage: "Uid is empty");
    try {
      final data = {"lastLat": position.latitude, "lastLong": position.longitude};

      await FirebaseFirestore.instance.collection(CollectionNames.users).doc(uid).set(data, SetOptions(merge: true));
      //.onError((error, stackTrace) => ApiResponse(success: false, data: null, errorMessage: error.toString()));
      return const ApiResponse(success: true, data: null, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<MyUser?>> getUserById(String id) async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.users).doc(id).get();
      if (response.exists && response.data() != null) {
        var myUser = MyUser.fromMap(response.data()!);
        return ApiResponse(success: true, data: myUser, statusCode: 200);
      }
      return const ApiResponse(success: false, data: null, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<MyUser?>> getAdmin() async {
    try {
      var response =
          await FirebaseFirestore.instance.collection(CollectionNames.users).where("role", isEqualTo: "admin").get();
      MyUser result = MyUser.fromMap(response.docs.first.data()) ;
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  void _saveLoginData(MyUser user) {
    var sharedPref = AppPreferenceUtil.instance;
    sharedPref.setBool(SharedPreferencesKey.isLoggedIn, true);
    sharedPref.setString(SharedPreferencesKey.userType, user.role ?? UserRoleEnum.elder.name);

    sharedPref.setString(SharedPreferencesKey.userName, user.name ?? "");
    sharedPref.setString(SharedPreferencesKey.userEmail, user.email ?? "");
    sharedPref.setString(SharedPreferencesKey.userId, user.uid ?? "");
    sharedPref.setString(SharedPreferencesKey.userModel, jsonEncode(user.toMap()));
  }

  Future<bool> _clearUserData() {
    return AppPreferenceUtil.instance.clear();
  }

  Future<DummyUser?> fetchDummyUser() async {
    var response = await get(Uri.parse("https://randomuser.me/api/"));

    if (response.statusCode == 200) {
      return DummyUser.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<ApiResponse<String?>> uploadImageFile(File file, String senderUid) async {
    try {
      final imageFileName = senderUid + DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref("profile");
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

  Future<ApiResponse<void>> updateUser(String uid, MyUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection(CollectionNames.users)
          .doc(uid)
          .update(user.copyWith(uid: uid).toMap());
      //.onError((error, stackTrace) => ApiResponse(success: false, data: null, errorMessage: error.toString()));
      return const ApiResponse(success: true, data: null, statusCode: 200);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "Wrong password provided for that user.");
      }
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<void>> sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const ApiResponse(success: true, data: null, statusCode: 200);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "Wrong password provided for that user.");
      }
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<void>> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        return const ApiResponse(success: false, data: null, errorMessage: "User not found");
      }
      var email = user.email!;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: currentPassword,
      );

      await user.updatePassword(newPassword);
      return const ApiResponse(success: true, data: null, statusCode: 200);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        return const ApiResponse(
            success: false, data: null, statusCode: 200, errorMessage: "Wrong password provided for that user.");
      }
      return ApiResponse(success: false, data: null, errorMessage: "${e.code} ${e.message}");
    }
  }
}
