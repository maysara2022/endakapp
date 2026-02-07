import 'package:endakapp/core/constants/end_points.dart';

class ConversationResponse {
  final bool success;
  final String message;
  final ConversationData data;

  ConversationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      success: json['success'],
      message: json['message'],
      data: ConversationData.fromJson(json['data']),
    );
  }
}

class ConversationData {
  final Partner partner;
  final List<Message> messages;

  ConversationData({
    required this.partner,
    required this.messages,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      partner: Partner.fromJson(json['partner']),
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
    );
  }
}

class Partner {
  final int id;
  final String name;
  final String? avatar;
  final String? email;
  final String? phone;

  Partner({
    required this.id,
    required this.name,
    this.avatar,
    this.email,
    this.phone,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String? content;
  final String? mediaUrl;
  final String? mediaPath;
  final String messageType;
  final bool isOwnMessage;
  final String formattedTime;
  final Metadata? metadata;
  final Partner? conversationPartner;
  final bool isRead;


  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.content,
    this.mediaUrl,
    this.mediaPath,
    required this.messageType,
    required this.isOwnMessage,
    required this.formattedTime,
    this.metadata, required this.isRead, this.conversationPartner,
  });

  factory Message.fromJson(Map<String, dynamic> json, {int? currentUserId}) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      isRead: json['is_read'],
      mediaUrl: json['media_url'] ?? (json['media_path'] != null ? '${EndPoints.web}${json['media_path']}' : null),
      mediaPath: json['media_path'],
      messageType: json['message_type'],
      isOwnMessage: currentUserId != null
          ? json['sender_id'] == currentUserId
          : json['is_own_message'] ?? false,
      formattedTime: json['formatted_time'],
      metadata: json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null,
      conversationPartner: json['conversation_partner'] != null
          ? Partner.fromJson(json['conversation_partner'])
          : null,
    );
  }
}

class Metadata {
  final String? fileName;
  final int? fileSize;
  final String? mimeType;

  Metadata({this.fileName, this.fileSize, this.mimeType});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      fileName: json['file_name'],
      fileSize: json['file_size'],
      mimeType: json['mime_type'],
    );
  }
}
