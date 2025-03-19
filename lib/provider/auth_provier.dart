import 'dart:convert';
import 'dart:io';

import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/repository/auth_repository.dart';
import 'package:elderly_care/utils/shared_pref_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/my_user.dart';

class AuthProvider with ChangeNotifier {
  MyUser? currentUser;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthProvider() {
    _loadUserFromSharePref();
  }

  Future<ApiResponse<UserCredential?>> _login(String email, String password) async {
    var authRepo = AuthRepository();

    isLoading = true;
    var response = await authRepo.loginWithEmailPassword(email, password);
    isLoading = false;
    if (response.success && response.data?.user?.uid != null) {
      var user = await authRepo.getUserById(response.data!.user!.uid);
      if (user.success) {
        currentUser = user.data;
        return response;
      } else {
        return ApiResponse(success: false, data: null, errorMessage: response.errorMessage);
      }
    }

    return response;
  }

  Future<ApiResponse?> login(String email, String password) async {
    if (isLoading) {
      return null;
    } else {
      return await _login(email, password);
    }
  }

  Future<void> logout() async {
    return await AuthRepository().logOut();
  }

  void _loadUserFromSharePref() {
    var storedValue = AppPreferenceUtil.getString(SharedPreferencesKey.userModel, "");
    if (storedValue.isNotEmpty) {
      var decoded = jsonDecode(storedValue);
      try {
        var result = MyUser.fromMap(decoded);
        currentUser = result;
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<ApiResponse> updateUser(MyUser user, String? imagePath) async {
    var authRepository = AuthRepository();
    var uid = currentUser?.uid;

    if (uid == null || uid.isEmpty) return const ApiResponse(success: false, data: false, errorMessage: "Invalid Uid");

    debugPrint('Debug AuthProvider.updateUser : $uid ');
    user = user.copyWith(uid: uid);

    if (imagePath != null) {
      var uploadTask = await authRepository.uploadImageFile(File(imagePath), uid);
      if (uploadTask.success) {
        user = user.copyWith(imageUrl: uploadTask.data);
      }
    }
    return _updateUser(authRepository, uid, user);
  }

  Future<ApiResponse<void>> _updateUser(AuthRepository authRepository, String uid, MyUser user) async {
    var updateResponse = await authRepository.updateUser(uid, user);
    if (updateResponse.success) {
      AppPreferenceUtil.setString(SharedPreferencesKey.userModel, jsonEncode(user.toMap()));
      currentUser = user;
      notifyListeners();
    }
    return updateResponse;
  }

  Future<ApiResponse<void>> changePasswordAndLogOut(String currentPassword, String newPassword) async {
    var updateResponse = await AuthRepository().changePassword(currentPassword,newPassword);
    return updateResponse;
  }

  Future<ApiResponse<void>> sendResetEmail(String email) async {
    var updateResponse = await AuthRepository().sendResetEmail(email);
    return updateResponse;
  }
}
