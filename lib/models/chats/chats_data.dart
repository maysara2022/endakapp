import 'package:endakapp/models/user/user_model.dart';

class ChatsData {
  final int id;
  final String? createdAt;
  final String? updatedAt;
  final int senderId;
  final int receiverId;
  final String? message;
  final bool isRead;
  final String? readAt;
  final bool? isDeleted;
  final String? deletedAt;
  final int? replyToMessageId;
  final String conversationId;
  final int? serviceId;
  final String? media;
  final String? content;
  final String? mediaPath;
  final String? voiceNotePath;
  final String messageType;
  final int? serviceOfferId;
  final String? fileName;
  final int? fileSize;
  final String formattedTime;
  final String? mediaUrl;
  final String? voiceNoteUrl;
  final bool isOwnMessage;
  final UserModel conversationPartner;
  final UserModel sender;
  final UserModel receiver;

  ChatsData({
  required this.id,
  required this.createdAt,
  required this.updatedAt,
  required this.senderId,
  required this.receiverId,
  this.message,
  required this.isRead,
  this.readAt,
  required this.isDeleted,
  this.deletedAt,
  this.replyToMessageId,
  required this.conversationId,
  this.serviceId,
  this.media,
  this.content,
  this.mediaPath,
  this.voiceNotePath,
  required this.messageType,
  this.serviceOfferId,
  this.fileName,
  this.fileSize,
  required this.formattedTime,
  this.mediaUrl,
  this.voiceNoteUrl,
  required this.isOwnMessage,
  required this.conversationPartner,
  required this.sender,
  required this.receiver,
  });

  factory ChatsData.fromJson(Map<String, dynamic> json) {
  return ChatsData(
  id: json['id'],
  createdAt: json['created_at'],
  updatedAt: json['updated_at'],
  senderId: json['sender_id'],
  receiverId: json['receiver_id'],
  message: json['message'],
  isRead: json['is_read'],
  readAt: json['read_at'],
  isDeleted: json['is_deleted'],
  deletedAt: json['deleted_at'],
  replyToMessageId: json['reply_to_message_id'],
  conversationId: json['conversation_id'],
  serviceId: json['service_id'],
  media: json['media'],
  content: json['content'],
  mediaPath: json['media_path'],
  voiceNotePath: json['voice_note_path'],
  messageType: json['message_type'],
  serviceOfferId: json['service_offer_id'],
  fileName: json['file_name'],
  fileSize: json['file_size'],
  formattedTime: json['formatted_time'],
  mediaUrl: json['media_url'],
  voiceNoteUrl: json['voice_note_url'],
  isOwnMessage: json['is_own_message'],
  conversationPartner:
  UserModel.fromJson(json['conversation_partner']),
  sender: UserModel.fromJson(json['sender']),
  receiver: UserModel.fromJson(json['receiver']),
  );
  }


}