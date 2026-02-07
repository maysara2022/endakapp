
import 'package:dio/dio.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';

class LoginController {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: EndPoints.api),
  );

  final Dio dioV1 = Dio(
    BaseOptions(baseUrl: EndPoints.main),
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
       EndPoints.login,
        queryParameters: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      print(e);
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }
  Future<void> logout() async {
    try {
      await UserPrefs.clearData();
      final token = await UserPrefs.getToken();
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dioV1.post('/v1/auth/logout');
      if (response.statusCode == 200 || response.statusCode == 201) {

      } else {
        return;
      }
    } on DioException catch (e) {
      return;
    } catch (e) {
      return;
    }
  }




}