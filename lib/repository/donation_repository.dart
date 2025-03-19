import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/donation.dart';
import 'package:elderly_care/models/notification.dart';
import 'package:elderly_care/repository/notification_repository.dart';

import '../models/api_response.dart';
import '../utils/db_collections.dart';
import '../widgets/in_app_notification_widget.dart';
import 'auth_repository.dart';

class DonationRepository {
  Future<ApiResponse> addDonation(Donation donation) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionNames.donations).add(donation.toMap());

      _sendNotificationToAdmin(donation);
      return const ApiResponse(success: true, data: true, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  _sendNotificationToAdmin(Donation donation) async {
    try {
      var admin = await AuthRepository().getAdmin();
      if (admin.success && admin.data != null && admin.data!.deviceToken != null) {
         NotificationRepository().sendNotification(
            _generateNotificationModelFromDonation(donation, admin.data!.deviceToken!), admin.data!.deviceToken!);

        return const ApiResponse(success: true, data: true, statusCode: 200);
      }
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: false, errorMessage: "${e.code} ${e.message}");
    }
  }

  Future<ApiResponse<List<Donation>>> getAllDonations() async {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionNames.donations).get();
      List<Donation> result = response.docs.map((e) => Donation.fromMap(e.data())).toList();
      return ApiResponse(success: true, data: result, statusCode: 200);
    } on FirebaseException catch (e) {
      return ApiResponse(success: false, data: [], errorMessage: "${e.code} ${e.message}");
    }
  }

  _generateNotificationModelFromDonation(Donation donation, String token) {
    return MyNotification(
      from: donation.from,
      to: token,
      title: "${donation.senderName} donated ${donation.amount}",
      subtitle: "${donation.receiverName} received ${donation.amount} from ${donation.senderName}",
      notificationType: NotificationType.info.name,
      timeStamp: donation.timeStamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
