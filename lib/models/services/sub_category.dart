class SubCategories {
  late int? id;
  late String? nameAr;
  late String? nameEn;
  late int? categoryId;
  late String? image;
  late String? descriptionAr;
  late String? descriptionEn;
  late bool? status;
  late String? createdAt;
  late String? updatedAt;

  SubCategories();

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    nameAr = json['name_ar'] ?? '';
    nameEn = json['name_en'] ?? '';
    categoryId = json['category_id'] ?? 0;
    image = json['image'] ?? '';
    descriptionAr = json['description_ar'];
    descriptionEn = json['description_en'];
    status = json['status'] ?? false;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
}
