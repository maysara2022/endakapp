import 'package:dio/dio.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/models/services/services_categories.dart';
import 'package:endakapp/models/services/sub_category.dart';

class CategoriesController {
  final Dio _dio = Dio(
    BaseOptions(baseUrl:EndPoints.main),
  );


  Future<List<ServicesCategories>> fetchCategories() async {
    try {
      final response = await _dio.get(EndPoints.categories);
      final productsJson = response.data['data'] as List;
      return productsJson.map((e) => ServicesCategories.fromJson(e)).toList();
    } catch (e) {
      print(e);

      throw Exception('فشل جلب المنتجات: $e');
    }
  }


  Future<List<SubCategories>> fetchSubCategories(String slug) async {
    try {
      final response = await _dio.get(
        'https://endak.net/api/v1/categories/$slug/details',
      );
      final subCategories =
      response.data?['data']?['category']?['sub_categories'];
      if (subCategories == null ||
          subCategories is! List ||
          subCategories.isEmpty) {
        return [];
      }

      return subCategories
          .map<SubCategories>(
            (e) => SubCategories.fromJson(e),
      )
          .toList();
    } catch (e) {
      print('ERROR: $e');
      return [];
    }
  }





}