class OfferModel {
  final int id;
  final int serviceId;
  final int providerId;
  final String price;
  final String notes;
  final String status;
  final String? acceptedAt;
  final String? deliveredAt;
  final int? rating;
  final String? review;
  final String? expiresAt;
  final String createdAt;
  final String updatedAt;
  final Provider provider;

  OfferModel({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.price,
    required this.notes,
    required this.status,
    this.acceptedAt,
    this.deliveredAt,
    this.rating,
    this.review,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    required this.provider,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      serviceId: json['service_id'],
      providerId: json['provider_id'],
      price: json['price'],
      notes: json['notes'],
      status: json['status'],
      acceptedAt: json['accepted_at'],
      deliveredAt: json['delivered_at'],
      rating: json['rating'],
      review: json['review'],
      expiresAt: json['expires_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      provider: json['provider'] != null
          ? Provider.fromJson(json['provider'])
          : Provider(id: 0, name: 'غير معروف', avatar: null),
    );
  }
}

class Provider {
  final int id;
  final String name;
  final String? avatar;

  Provider({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class Service {
  final int id;
  final String title;
  final String slug;
  final int userId;

  Service({
    required this.id,
    required this.title,
    required this.slug,
    required this.userId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      userId: json['user_id'],
    );
  }
}
