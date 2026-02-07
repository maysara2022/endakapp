import 'dart:io';
import 'package:dio/dio.dart';
import 'package:endakapp/controllers/auth/login/login_controller.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/models/user/user_model.dart';
import 'package:endakapp/views/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class UserProfileController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final LoginController loginController = Get.put(LoginController());




  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      String token = await UserPrefs.getToken();

      final response = await Dio().get(
        '${EndPoints.main}/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data != null && response.data['data'] != null) {
        user.value = UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('لا توجد بيانات مستخدم');
      }
    } catch (e) {
      errorMessage.value = 'فشل تحميل بيانات المستخدم: ${e.toString()}';
      Get.snackbar(
        'خطأ',
        'تعذر جلب البيانات',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    await fetchUserData();
  }




  void goToSettings() async{
    await loginController.logout();
     Get.offAll(() => LoginScreen());
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  String getAccountAge() {
    if (user.value?.createdAt == null) return 'غير معروف';
    try {
      final createdDate = DateTime.parse(user.value!.createdAt!);
      final now = DateTime.now();
      final difference = now.difference(createdDate);

      if (difference.inDays < 30) {
        return '${difference.inDays} يوم';
      } else if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()} شهر';
      } else {
        return '${(difference.inDays / 365).floor()} سنة';
      }
    } catch (e) {
      return 'غير معروف';
    }
  }

  String getUserTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'customer':
        return 'مستخدم عادي';
      case 'provider':
        return 'مزود خدمة';
      case 'admin':
        return 'مسؤول';
      default:
        return type;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? bio,
    File? avatar,
  }) async {
    String token = await UserPrefs.getToken();

    try {
      Map<String, dynamic> dataMap = {
        'name': name,
        'email': email,
      };

      if (phone != null && phone.isNotEmpty) dataMap['phone'] = phone;
      if (bio != null && bio.isNotEmpty) dataMap['bio'] = bio;

      if (avatar != null) {
        dataMap['avatar'] = await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        );
      }
      FormData formData = FormData.fromMap(dataMap);
      final response = await Dio().post(
        '${EndPoints.main}/auth/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: formData,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
