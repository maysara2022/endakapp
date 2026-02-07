import 'dart:async';

import 'package:dio/dio.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/models/notifications/notifications_model.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NotificationsController extends GetxController{

  var unreadCount = 0.obs;
  Timer? _timer;


  Future<List<NotificationModel>> fetchNotifications() async {
    try {

      String token = await UserPrefs.getToken();
      final response = await Dio().get(
        '${EndPoints.main}${EndPoints.notifications}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final List list =
      response.data['data']['notifications']['data'];

      return list.map((e) => NotificationModel.fromJson(e)).toList();

    } catch (e) {
      throw Exception('فشل تحميل الإشعارات');
    }
  }
  Future<void> deleteNotification(int notificationId) async {
    try {
      String token = await UserPrefs.getToken();

      await Dio().delete(
        '${EndPoints.main}${EndPoints.notifications}/$notificationId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('فشل حذف الإشعار');
    }
  }
  Future<void> markAllNotificationsAsRead() async {
    try {
      String token = await UserPrefs.getToken();
      await Dio().post(
        '${EndPoints.main}/notifications/mark-all-read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      return;
    }
  }





  @override
  void onInit() {
    super.onInit();
    // بدء التحديث التلقائي
    _startAutoRefresh();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startAutoRefresh() {
    updateUnreadCount();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      updateUnreadCount();
    });
  }

  Future<void> updateUnreadCount() async {
    try {
      List<NotificationModel> notifications = await fetchNotifications();
      int count = notifications.where((n) => n.readAt == null).length;
      unreadCount.value = count;
    } catch (e) {
      print('Error updating unread count: $e');
      unreadCount.value = 0;
    }
  }

  Future<int> getUnreadNotificationsCount() async {
    try {
      List<NotificationModel> notifications = await fetchNotifications();
      int unreadCount = notifications.where((n) => n.readAt == null).length;
      return unreadCount;
    } catch (e) {
      return 0;
    }
  }

  void stopAutoRefresh() {
    _timer?.cancel();
  }

  void resumeAutoRefresh() {
    _startAutoRefresh();
  }

}