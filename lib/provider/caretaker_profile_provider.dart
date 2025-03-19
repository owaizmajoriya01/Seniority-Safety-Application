import 'package:elderly_care/models/api_response.dart';
import 'package:elderly_care/models/my_review.dart';
import 'package:elderly_care/models/my_user.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../repository/assigned_repository.dart';
import '../repository/review_repository.dart';
import '../utils/shared_pref_helper.dart';

class ProfileProvider with ChangeNotifier {
  MyUser? selectedUser;
  bool _isLoading = false;

  final List<MyReview> _reviews = [];
  final List<MyUser> _assignedCareTakers = [];
  final List<MyUser> _assignedElders = [];

  List<MyReview> get reviews => UnmodifiableListView(_reviews);

  List<MyUser> get assignedCareTakers => UnmodifiableListView(_assignedCareTakers);

  List<MyUser> get assignedElders => UnmodifiableListView(_assignedElders);

  double rating = 0.0;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setUser(MyUser user) async {
    clearProvider();
    isLoading = true;
    selectedUser = user;
    var role = user.roleStringToEnum();
    debugPrint('Debug ProfileProvider.setUser : $role ');
    if (role == UserRoleEnum.caretaker) {
      await Future.wait([_loadReviews(), _getAssignedElders()]);
      rating = _calculateRating();
    } else if (role == UserRoleEnum.elder) {
      await _getAssignedCaretakers();
    }

    isLoading = false;
  }

  void clearProvider() {
    rating = 0.0;
    _reviews.clear();
    _assignedCareTakers.clear();
    _assignedElders.clear();
  }

  Future<void> _loadReviews() async {
    var response = await ReviewRepository().getAllReviewByReceiverId(selectedUser!.uid!);
    if (response.success) {
      debugPrint('Debug ProfileProvider._loadReviews : ${response.data} ');
      _reviews.addAll(response.data);
    }
  }

  Future<ApiResponse<bool>> addReview(String review, double rating) async {
    if (selectedUser?.uid == null) {
      return const ApiResponse(
          success: false, data: false, errorMessage: "Something went wrong.\nPlease refresh this page and try again");
    }
    isLoading = true;
    var currentUserUid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    var name = AppPreferenceUtil.getString(SharedPreferencesKey.userName);

    var myReview = MyReview(
        senderUid: currentUserUid,
        receiverUid: selectedUser!.uid!,
        rating: rating,
        description: review,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        senderName: name);
    var response = await _addReview(myReview);
    if (response.success) {
      rating = _calculateRating();
      isLoading = false;
    }
    return response;
  }

  Future<ApiResponse<bool>> _addReview(MyReview review) async {
    var response = await ReviewRepository().addReview(review);
    if (response.success) {
      _reviews.add(review);
    }
    return response;
  }

  double _calculateRating() {
    if (_reviews.isEmpty) return 0.0;

    double total = 0;
    for (var review in _reviews) {
      total += review.rating;
    }
    return total / _reviews.length;
  }

  bool get shouldShowReviewButton {
    var currentUserUid = AppPreferenceUtil.getString(SharedPreferencesKey.userId);
    if (currentUserUid == selectedUser?.uid) return false;

    var currentUserReview = _reviews.firstWhereOrNull((element) => element.senderUid == currentUserUid);

    return currentUserReview == null;
  }

  Future<void> _getAssignedCaretakers() async {
if(selectedUser?.uid==null)return;

    var elders = await AssignedRepository().getCareTakersAssignedTo(selectedUser!.uid!);

    if (elders.success && elders.data.isNotEmpty) {
      _assignedCareTakers.addAll(elders.data);
    }
  }

  Future<void> _getAssignedElders() async {
    if(selectedUser?.uid==null)return;


    var elders = await AssignedRepository().getEldersAssignedTo(selectedUser!.uid!);

    if (elders.success && elders.data.isNotEmpty) {
      _assignedElders.addAll(elders.data);
    }
  }
}
