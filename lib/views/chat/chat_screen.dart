import 'package:endakapp/controllers/chats/chats_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/core/widgets/connection_faild.dart';
import 'package:endakapp/models/chats/chats_data.dart';
import 'package:endakapp/views/chat/converstion_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
 late Future<List<ChatsData>> futureChats;

class _ChatScreenState extends State<ChatScreen> {
  late final ChatsController _chatsController = Get.put(ChatsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
      ),
      body: FutureBuilder<List<ChatsData>>(
        future: _chatsController.fetchConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: ConnectionFailed(fun: () {
              _retryFetch();
            }));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد محادثات'));
          }

          final chats = snapshot.data!;

          // نأخذ آخر رسالة لكل conversation_id
          Map<String, ChatsData> lastMessagesMap = {};
          for (var chat in chats) {
            if (!lastMessagesMap.containsKey(chat.conversationId) ||
                DateTime.parse(chat.createdAt)
                    .isAfter(DateTime.parse(
                    lastMessagesMap[chat.conversationId]!.createdAt))) {
              lastMessagesMap[chat.conversationId] = chat;
            }
          }

          final lastMessages = lastMessagesMap.values.toList();
          return ListView.builder(
            itemCount: lastMessages.length,
            itemBuilder: (context, index) {
              final chat = lastMessages[index];
              final partner = chat.conversationPartner;

              String lastMessage = '';
              if (chat.message != null && chat.message!.isNotEmpty) {
                lastMessage = chat.message!;
              } else if (chat.content != null && chat.content!.isNotEmpty) {
                lastMessage = chat.content!;
              } else if (chat.messageType == 'image') {
                lastMessage = '📷 صورة';
              } else if (chat.messageType == 'voice') {
                lastMessage = '🎤 صوت';
              }

              return InkWell(
                onTap: () async {

                  Get.to(ChatScreen);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    backgroundImage: partner.avatar != null
                        ? NetworkImage(partner.avatar!)
                        : null,
                    child: partner.avatar == null
                        ? Text(partner.name[0])
                        : null,
                  ),
                  title: Text(
                    partner.name,
                    style: TextStyle(color: AppColors.blackColor),
                  ),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Text(
                    chat.formattedTime,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () async {
                    int id = await UserPrefs.getId();

                    Get.to(ChatsScreen(myUserId: id, partnerId: partner.id));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _retryFetch() {
    setState(() {
      futureChats = _chatsController.fetchConversations();
    });
  }
}
