class ServicesCategories {
 late int? id;
 late String? name;
 late String? slug;
 late String? nameEn;
 late String? description;
 late String? descriptionAr;
 late String? image;
 late String? parentId;
 late String? createdAt;


  ServicesCategories();

  ServicesCategories.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    name = json['name']??'';
    slug = json['slug']??'';
    nameEn = json['name_en']??'';
    description = json['description']??'';
    descriptionAr = json['description_ar']??'';
    image = json['image']??'';
    parentId = json['parent_id']??'';
    createdAt = json['created_at']??'';

    }
  }

