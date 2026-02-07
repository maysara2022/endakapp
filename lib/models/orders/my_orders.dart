import 'package:endakapp/models/offers/offer_model.dart';

class MyOrders {
  final String? createdAt;
  final String? category;
  final String? description;
  final String? imageUrl;
  final bool? isActive;
  final Map<String, dynamic>? customFields;
  final String? title;
  final String? price;
  final int? id;
  final String? metaTitle;
  final List<OfferModel>? offers;




  MyOrders({
    this.createdAt,
    this.category,
    this.description,
    this.imageUrl,
    this.isActive,
    this.customFields,
    this.title,
    this.price,
    this.id,
    this.metaTitle,
    this.offers,
  });

  factory MyOrders.fromJson(Map<String, dynamic> json) {
    return MyOrders(
      id: json['id'] as int?,
      title: json['title'] as String?,
      createdAt: json['updated_at'] as String?,
      category: json['category']?['name'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image'] as String?,
      isActive: json['is_active'] as bool?,
      price: json['price'] as String?,
      metaTitle: json['meta_title'] as String?,

      offers: json['offers'] != null
          ? (json['offers'] as List).map((e) => OfferModel.fromJson(e)).toList()
          : [], // أو null إذا كانت nullable

      customFields: json['custom_fields'] != null
          ? Map<String, dynamic>.from(json['custom_fields'] as Map)
          : null,
    );
  }

  double? get priceAsDouble => price != null ? double.tryParse(price!) : null;

  String? getCustomField(String key) {
    if (customFields == null) return null;
    final value = customFields![key];
    if (value is List && value.isNotEmpty) {
      return value[0].toString();
    }
    return value?.toString();
  }

}