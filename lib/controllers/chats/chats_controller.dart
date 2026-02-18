import 'package:dio/dio.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/models/chats/chats_data.dart';
import 'package:endakapp/models/chats/message_data.dart';

import '../../core/constants/end_points.dart';

class ChatsController {
  final Dio _dio = Dio(
    BaseOptions(baseUrl:EndPoints.main),
  );


  Future<List<ChatsData>> fetchConversations() async {
    try {
      String token = await UserPrefs.getToken();

      final response = await _dio.get(
        EndPoints.messages,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List list = response.data['data'];

      return list
          .map((e) => ChatsData.fromJson(e))
          .toList();


    } catch (e) {
      throw Exception('فشل تحميل المحادثات$e');
    }
  }
  Future<List<Message>> fetchMessages(int partnerId) async {
    try {
      String token = await UserPrefs.getToken();

      final response = await _dio.get(
        '${EndPoints.messages}/$partnerId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final messagesJson = response.data['data']['messages'] as List;
        return messagesJson.map((e) => Message.fromJson(e)).toList();
      } else {
        throw Exception('فشل جلب الرسائل');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      throw Exception('فشل جلب الرسائل: $e');
    }
  }

  Stream<List<Message>> messagesStream(int partnerId) async* {
    while (true) {
      try {
        final messages = await fetchMessages(partnerId);

        // فلترة الرسائل بينك وبين الشريك
        final filteredMessages = messages.where((msg) {
          return (msg.senderId == partnerId || msg.receiverId == partnerId);
        }).toList();

        yield filteredMessages;
      } catch (e) {
        print('Error in messagesStream: $e');
        yield []; // في حالة حدوث خطأ
      }

      await Future.delayed(const Duration(seconds: 2)); // polling كل 2 ثانية
    }
  }


// في ChatsController
  Future<void> sendMessage({
    required int senderId,
    required int receiverId,
    required String content,
    required String messageType,
  }) async {
    try {
      String token = await UserPrefs.getToken();

      final response = await _dio.post(
        '${EndPoints.messages}', // استعمل receiverId أو حسب API
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'sender_id': senderId,
          'receiver_id': receiverId,
          'content': content,
          'message_type': messageType,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل إرسال الرسالة');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('فشل إرسال الرسالة: $e');
    }
  }


}