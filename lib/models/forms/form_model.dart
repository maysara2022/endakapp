class FormModel {
  final int id;
  final String name;
  final String nameAr;
  final String nameEn;
  final String type;
  final dynamic value;
  final List<dynamic>? options;
  final bool isRequired;
  final bool isRepeatable;
  final int sortOrder;
  final int? subCategoryId;

  FormModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    this.value,
    this.options,
    required this.isRequired,
    required this.isRepeatable,
    required this.sortOrder,
    this.subCategoryId,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      type: json['type'],
      value: json['value'],
      options: json['options'],
      isRequired: json['is_required'] ?? false,
      isRepeatable: json['is_repeatable'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      subCategoryId: json['sub_category_id'],
    );
  }
}
