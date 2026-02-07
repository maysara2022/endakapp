class UserModel {
  final int id;
  final String name;
  final String email;
  final bool isAdmin;
  final String userType;
  final String phone;
  final String? image;
  final String? phoneVerifiedAt;
  final String? bio;
  final String? avatar;
  final String? emailVerifiedAt;
  final String? deviceToken;
  final String? createdAt;
  final String? updatedAt;
  final String? termsAcceptedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.userType,
    required this.phone,
    this.image,
    this.phoneVerifiedAt,
    this.bio,
    this.avatar,
    this.emailVerifiedAt,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.termsAcceptedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      userType: json['user_type'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      phoneVerifiedAt: json['phone_verified_at'],
      bio: json['bio'],
      avatar: json['avatar'],
      emailVerifiedAt: json['email_verified_at'],
      deviceToken: json['device_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      termsAcceptedAt: json['terms_accepted_at'],
    );
  }
}