import 'package:dio/dio.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';

class RegisterController {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: EndPoints.api),
  );

  Future register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final url = EndPoints.register;

    final data = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation, // ← مهم
      "user_type": "customer",
      if (phone != null) "phone": phone,
    };

    print('━━━━━━━━━━ REGISTER REQUEST ━━━━━━━━━━');
    print('URL: $url');
    print('HEADERS: ${_dio.options.headers}');
    print('BODY: $data');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    try {
      final response = await _dio.post(url, data: data);

      print('━━━━━━━━━━ REGISTER RESPONSE ━━━━━━━━━━');
      print('STATUS CODE: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');





    } on DioException catch (e) {
      print('━━━━━━━━━━ REGISTER ERROR ━━━━━━━━━━');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('ERROR DATA: ${e.response?.data}');
      print('ERROR HEADERS: ${e.response?.headers}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      throw Exception('فشل التسجيل: ${e.response?.data}');
    }
  }

}