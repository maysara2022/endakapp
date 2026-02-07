import 'package:dio/dio.dart';
import 'package:endakapp/core/constants/app_process.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/models/cities/cities.dart';
import 'package:endakapp/models/forms/form_model.dart';
import 'package:endakapp/models/offers/offer_model.dart';
import 'package:endakapp/models/orders/my_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

class OrdersController extends GetxController {
  final Map<String, TextEditingController> textControllers = {};
  final RxMap<String, dynamic> formValues = <String, dynamic>{}.obs;
  Rx<CityModel?> selectedCity = Rx<CityModel?>(null);


  var isLoading = false.obs;
  var selectedOrder = Rxn<MyOrders>();
  var orderOffers = <OfferModel>[].obs;



  final Dio _dio = Dio(
    BaseOptions(baseUrl: '${EndPoints.main}${EndPoints.myOrders}'),
  );

  Future<List<MyOrders>> fetchMyOrders() async {
    String token = await UserPrefs.getToken();
    try {
      final response = await _dio.get(
        '${EndPoints.main}${EndPoints.myOrders}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final dataList = response.data['data']['data'] as List? ?? [];

      print('📦 عدد الطلبات: ${dataList.length}');
      if (dataList.isNotEmpty) {
        print('🔍 أول طلب: ${dataList[0]}');
        print('📝 custom_fields: ${dataList[0]['custom_fields']}');
      }

      return dataList
          .map((e) => MyOrders.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('فشل جلب البيانات: $e');
    }
  }


  Future<MyOrders?> fetchMyOrderById(int orderId) async {
    isLoading.value = true;
    orderOffers.clear();

    String token = await UserPrefs.getToken();

    try {
      final response = await _dio.get(
        '${EndPoints.main}${EndPoints.myOrders}/$orderId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data['data'];
      if (data == null) {
        isLoading.value = false;
        return null;
      }

      final orderData = Map<String, dynamic>.from(data);
      if (orderData['custom_fields'] is! Map) {
        orderData['custom_fields'] = null;
      }

      final order = MyOrders.fromJson(orderData);

      // تخزين الطلب والعروض
      selectedOrder.value = order;
      if (order.offers != null && order.offers!.isNotEmpty) {
        orderOffers.value = order.offers!;
      }

      isLoading.value = false;
      return order;

    } catch (e) {
      isLoading.value = false;
      print('Error fetching order $orderId: $e');
      throw Exception('فشل جلب الطلب: $e');
    }
  }

  Future<List<MyOrders>> searchServices({
    int? category,
    int? city,
    String? user,
    int? subCategory,
    String? searchTerm,
  }) async {
    String token = await UserPrefs.getToken();

    try {
      final response = await _dio.get(
        '${EndPoints.main}/services/search',
        queryParameters: {
          'category': category,
          'city': city,
          'user': user,
          'subCategory': subCategory,
          'search': searchTerm,
        },

      );

      final dataList =
          response.data['data']['services'] as List? ?? [];

      print('🔎 عدد الخدمات: ${dataList.length}');
      if (dataList.isNotEmpty) {
        print('📌 أول خدمة: ${dataList[0]}');
      }

      return dataList
          .map((e) => MyOrders.fromJson(
        Map<String, dynamic>.from(e),
      ))
          .toList();

    } catch (e) {
      print('Error fetching services: $e');
      throw Exception('فشل جلب البيانات: $e');
    }
  }





  Future<OfferModel?> fetchOfferById(int offerId) async {
    String token = await UserPrefs.getToken();

    try {
      final response = await _dio.get(
        '${EndPoints.main}${EndPoints.myOrders}/$offerId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data == null) {
        print('Response data is null for offer $offerId');
        return null;
      }

      final data = response.data['data'];
      if (data == null) {
        print('Data is null for offer $offerId');
        return null;
      }

      return OfferModel.fromJson(data);

    } on DioException catch (e) {
      return null;
    }
  }

  Future<List<FormModel>> fetchFormFields({String? subCategoryId}) async {
    try {
      final response = await _dio.get(
        'https://endak.net/api/v1/categories/$subCategoryId/fields',
      );

      final List fieldsList = response.data['data']['fields'] as List? ?? [];

      // print('Fields (English names only):');
      // if (fieldsList.isEmpty) {
      //   print('  (لا توجد حقول)');
      // } else {
      //   for (var field in fieldsList) {
      //     print(
      //       ' - ${field['name_en'] ?? '(no name)'}- ${field['type'] ?? '(no name)'}',
      //     );
      //   }
      // }
      return fieldsList
          .map((e) => FormModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      print('Error fetching form fields: $e');
      throw Exception('فشل جلب الحقول: $e');
    }
  }

  Future<List<CityModel>> getAllCities() async {
    try {
      final response = await _dio.get(
        'https://endak.net/api/v1/cities',
      );

      final List data = response.data['data'];
      return data.map((e) => CityModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('فشل تحميل المدن');
    }
  }

  Future<List<CityModel>> getCities(String id) async {
    final response = await _dio.get(
      'https://endak.net/api/v1/categories/$id/cities',
    );
    final List data = response.data['data'];
    return data.map((e) => CityModel.fromJson(e)).toList();
  }

  void setSelectedCity(CityModel? city) {
    selectedCity.value = city;
    update();
  }


  Future<void> submitCustomFields(
      String id,
      String title,
      String description,
      String selectedCity,
      String imageUrl,
      String? metaTitle,
      Map<String, dynamic> customValues,
      ) async {
    try {
      print('''
      📤 Data being sent:
      -------------------
      title        : $title
      description  : $description
      image_url    : $imageUrl
      price        : 100.0
      category_id  : $id
      city_id      : $selectedCity
      custom_fields: ${customValues.entries.map((e) => '  - ${e.key}: ${e.value}').join('\n')}
      -------------------
      ''');

      final Dio dio = Dio();
      String token = await UserPrefs.getToken();

      dio.options.headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      };

      FormData formData = FormData.fromMap({
        "title": title,
        "description": description,
        "image": imageUrl,
        "category_id": id,
        "city_id": selectedCity,
      });

      for (var entry in customValues.entries) {
        if (entry.value is XFile) {
          formData.files.add(
            MapEntry(
              'custom_fields[${entry.key}]',
              await MultipartFile.fromFile(
                entry.value.path,
                filename: entry.value.name,
              ),
            ),
          );
        } else {
          // إذا كان الحقل نصي أو رقمي
          formData.fields.add(
            MapEntry('custom_fields[${entry.key}]', entry.value.toString()),
          );
        }
      }

      // إرسال الطلب
      final response = await dio.post(
        "https://endak.net/api/v1/services",
        data: formData,
      );
      AppProcess.success('نجح', 'تم إرسال الطلب بنجاح');
    } on DioException catch (e) {
      if (e.response != null) {
        AppProcess.warring('تنبيه', 'الرجاء التحقق من صحة البيانات');

        print("❌ Response data: ${e.response!.data}");
        print("❌ Status code: ${e.response!.statusCode}");
      }
      //  print("❌ خطأ أثناء الإرسال: $e");
      rethrow;
    } catch (e) {
      // print("❌ خطأ غير متوقع: $e");
      rethrow;
    }
  }

}
