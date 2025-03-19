import 'dart:collection';
import 'dart:math';

import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/models/donation.dart';
import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/models/old_age_home.dart';
import 'package:elderly_care/repository/admin_repository.dart';
import 'package:elderly_care/repository/assigned_repository.dart';
import 'package:elderly_care/repository/auth_repository.dart';
import 'package:elderly_care/repository/donation_repository.dart';
import 'package:elderly_care/repository/notification_repository.dart';
import 'package:elderly_care/utils/date_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../models/assigned.dart';
import '../repository/old_age_repository.dart';

class AdminUiState with ChangeNotifier {
  final List<MyUser> _elder = [];
  final List<MyUser> _caretaker = [];
  final List<OldAgeHome> _oldAgeHomes = [];
  final List<Donation> _donations = [];

  List<MyUser> get elderList => UnmodifiableListView(_elder);

  List<MyUser> get caretakerList => UnmodifiableListView(_caretaker);

  List<OldAgeHome> get oldAgeHomeList => UnmodifiableListView(_oldAgeHomes);

  List<Donation> get donationList => UnmodifiableListView(_donations);

  AdminUiState() {
    init();
  }

  init() {
    Future.wait<void>([_fetchAllUser(), _fetchAllNotification(), _fetchAllOldAgeHome(), _fetchAllDonations()])
        .then((value) {
      notifyListeners();
    });
  }

  Future<void> _fetchAllUser() async {
    var adminRepository = AdminRepository();
    var users = await adminRepository.getAllUsers();
    _elder.addAll(users.data.where((element) => element.role == UserRoleEnum.elder.name));
    _caretaker.addAll(users.data.where((element) => element.role == UserRoleEnum.caretaker.name));

    debugPrint("AdminUiState._fetchAllUser : $users ");
  }

  Future<void> _fetchAllNotification() async {
    var notificationRepository = NotificationRepository();
    notificationRepository.getAllNotifications();
  }

  Future<void> _fetchAllOldAgeHome() async {
    var oldAgeHomeRepository = OldAgeHomeRepository();
    var response = await oldAgeHomeRepository.getAllHome();
    if (response.success) {
      _oldAgeHomes.clear();
      _oldAgeHomes.addAll(response.data);
    }
  }

  Future<void> _fetchAllDonations() async {
    var donationRepository = DonationRepository();
    var response = await donationRepository.getAllDonations();
    if (response.success) {
      _donations.clear();
      _donations.addAll(response.data);
    }
  }

  Future<ApiResponse<UserCredential?>> createUser(MyUser user, String password) async {
    if (user.email == null) {
      return const ApiResponse(success: false, errorMessage: "Email is required", data: null);
    }

    var authRepository = AuthRepository();
    var credentials = await authRepository.createUserWithEmailPassword(user.email!, password);
    if (credentials.data?.user?.uid != null) {
      var response = await authRepository.createUserInDb(credentials.data!.user!.uid, user);

      if (response.success && response.data != null) {
        var role = user.roleStringToEnum();
        if (role == UserRoleEnum.caretaker) {
          _caretaker.add(response.data!);
        } else if (role == UserRoleEnum.elder) {
          _elder.add(response.data!);
        }
        notifyListeners();
      }

      return ApiResponse(success: true, errorMessage: null, data: credentials.data);
    } else {
      return ApiResponse(success: false, errorMessage: credentials.errorMessage, data: null);
    }
  }

  Future<ApiResponse<bool>> createElder(MyUser user, String password, MyUser careTaker) async {
    var response = await createUser(user, password);
    if (response.success && response.data?.user?.uid != null) {
      var assigned = _createAssignedFromCaretaker(careTaker, response.data!.user!.uid);
      var assignedResponse = await AssignedRepository().addAssigned(assigned);
      return assignedResponse;
    } else {
      return ApiResponse(success: false, data: false, errorMessage: response.errorMessage);
    }
  }

  Assigned _createAssignedFromCaretaker(MyUser careTaker, String uid) {
    return Assigned(
        uid: null, elderUid: uid, careTakerUid: careTaker.uid!, assignedOn: DateTime.now().millisecondsSinceEpoch);
  }

  Future<ApiResponse> createOldAgeHome(OldAgeHome oldAgeHome) async {
    var oldAgeHomeRepo = OldAgeHomeRepository();
    var response = await oldAgeHomeRepo.addHome(oldAgeHome);

    if (response.success && response.data != null) {
      _oldAgeHomes.add(response.data!);
      notifyListeners();
    }

    return response;
  }

  Future<ApiResponse> updateOldAgeHome(OldAgeHome oldAgeHome) async {
    var oldAgeHomeRepo = OldAgeHomeRepository();
    var response = await oldAgeHomeRepo.updateHome(oldAgeHome);

    if (response.success) {
      var index = _oldAgeHomes.indexWhere((element) => element.uid == oldAgeHome.uid);
      if (index != -1) {
        _oldAgeHomes[index] = oldAgeHome;
        notifyListeners();
      }
    }

    return response;
  }

  Future<void> refreshUser() async {
    _caretaker.clear();
    _elder.clear();
    await _fetchAllUser();
    notifyListeners();
  }

  Future<void> disableAccount(MyUser user) async {
    if (user.uid == null) return;
    _toggleAccount(user, true);
  }

  Future<void> enableAccount(MyUser user) async {
    if (user.uid == null) return;
    await _toggleAccount(user, false);
  }

  Future<ApiResponse> _toggleAccount(MyUser user, bool shouldDisable) async {
    ApiResponse response;
    if (shouldDisable) {
      response = await AdminRepository().disableAccount(user.uid!);
    } else {
      response = await AdminRepository().enableAccount(user.uid!);
    }
    if (response.success) {
      var role = user.roleStringToEnum();
      if (role == UserRoleEnum.elder) {
        _updateLocalListState(_elder, user, shouldDisable);
      } else if (user.roleStringToEnum() == UserRoleEnum.caretaker) {
        _updateLocalListState(_caretaker, user, shouldDisable);
      }
    }
    return response;
  }

  void _updateLocalListState(List<MyUser> list, MyUser user, bool shouldDisable) {
    int index = list.indexOf(user);
    if (index != -1) {
      list[index] = user.copyWith(isEnabled: !shouldDisable);
      notifyListeners();
    }
  }

  /// ----------------------------------Test Functions --------------------------------

  Future<ApiResponse<bool>> createUserWithFakeData() async {
    var result = await AuthRepository().fetchDummyUser();
    var fakeUser = result?.results?.firstOrNull;
    if (fakeUser == null) {
      return const ApiResponse(success: false, data: false, errorMessage: "Failed to generate Dummy user");
    }

    var authRepository = AuthRepository();
    var credentials = await authRepository.createUserWithEmailPassword(fakeUser.email!, "12345678aA");
    if (credentials.data?.user?.uid != null) {
      var user = _createMyUSerFromDummyData(fakeUser, credentials.data!.user!.uid, UserRoleEnum.caretaker);
      var response = await authRepository.createUserInDb(credentials.data!.user!.uid, user);

      if (response.success && response.data != null) {
        _caretaker.add(response.data!);
        notifyListeners();
      }

      return const ApiResponse(success: true, errorMessage: null, data: true);
    } else {
      return ApiResponse(success: false, errorMessage: credentials.errorMessage, data: false);
    }
  }

  MyUser _createMyUSerFromDummyData(Result user, String? uid, UserRoleEnum role) {
    return MyUser(
        uid: uid,
        name: user.name?.fullName ?? "-",
        gender: user.gender,
        email: user.email,
        mobile: user.formattedMobileNumber,
        dateOfBirth: MyDateUtils.parseDate(date: user.dob?.date ?? DateTime(1982), toDateFormat: "yyyy-MM-dd"),
        address: user.location?.fullAddress ?? "-",
        role: role.name,
        lastLat: 0,
        lastLong: 0,
        deviceToken: "",
        imageUrl: user.picture?.medium);
  }

  Future<ApiResponse<bool>> createElderWithFakeData() async {
    var result = await AuthRepository().fetchDummyUser();
    var fakeUser = result?.results?.firstOrNull;
    if (fakeUser == null) {
      return const ApiResponse(success: false, data: false, errorMessage: "Failed to generate Dummy user");
    }

    var user = _createMyUSerFromDummyData(fakeUser, null, UserRoleEnum.elder);
    return await createElder(user, "12345678aA", _getRandomElement(_caretaker));
  }

  MyUser _getRandomElement(List<MyUser> list) {
    var random = Random();
    return list[random.nextInt(list.length)];
  }

  Future<ApiResponse> deleteUser(MyUser user, bool isCaretaker) async {
    if (user.uid != null && user.uid?.isNotEmpty == true) {
      var response = await AdminRepository().deleteUser(user.uid!);
      if (response.success) {

        if (isCaretaker) {
          var index = _caretaker.indexWhere((element) => element.uid == user.uid);
          debugPrint('Debug AdminUiState.deleteUser : $index');
          debugPrint('Debug AdminUiState.deleteUser : ${user.uid}');
          if (index != -1) {
            _caretaker.removeAt(index);
          }
        } else {
          var index = _elder.indexWhere((element) => element.uid == user.uid);
          if (index != -1) {
            _elder.removeAt(index);
          }
        }
        notifyListeners();
      }
      return response;
    }
    else{
      return const ApiResponse(success: false, data: null,errorMessage: "Invalid User Id");
    }
  }
}
