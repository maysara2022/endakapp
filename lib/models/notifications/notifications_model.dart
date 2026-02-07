import 'notifications_data.dart';

class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;
  final NotificationData data;


  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.readAt,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      readAt:
      json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      data: NotificationData.fromJson(json['data']),
    );
  }
}
