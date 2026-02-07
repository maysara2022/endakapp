import 'package:endakapp/controllers/chats/chats_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/chats/message_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  final int myUserId;
  final int partnerId;

  const ChatsScreen({
    super.key,
    required this.myUserId,
    required this.partnerId,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ChatsController _chatsController = Get.put(ChatsController());
  final TextEditingController _messageController = TextEditingController();
  late Future<List<Message>> _messagesFuture;
  String? _partnerName;
  String? _partnerAvatar;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      // استدعي دالة إرسال الرسالة من الـ Controller
      await _chatsController.sendMessage(
        senderId: widget.myUserId,
        receiverId: widget.partnerId,
        content: messageText,
        messageType: 'text',
      );

    } catch (e) {
      // إظهار رسالة خطأ
      Get.snackbar(
        'خطأ',
        'فشل إرسال الرسالة',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.secondaryColor,
              backgroundImage: _partnerAvatar != null ? NetworkImage(_partnerAvatar!) : null,
              child: _partnerAvatar != null
                  ? null // إذا في صورة، نعرضها
                  : Text(
                _partnerName != null && _partnerName!.isNotEmpty
                    ? _partnerName![0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),
            // اسم المستخدم
            Expanded(
              child: Text(
                _partnerName ?? 'المحادثة',
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // قائمة الرسائل
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatsController.messagesStream(widget.partnerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('حدث خطأ في تحميل الرسائل'),
                        ElevatedButton(
                          onPressed: () {}, // ممكن تضيف إعادة تحميل يدوية
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(child: Text('لا توجد رسائل مع هذا المستخدم'));
                }

                // حفظ معلومات الشريك من أول رسالة
                if (_partnerName == null) {
                  final firstMsg = messages.first;
                  _partnerName = firstMsg.conversationPartner?.name;
                  _partnerAvatar = firstMsg.conversationPartner?.avatar;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {});
                  });
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    return _messageBubble(msg);
                  },
                );
              },
            ),
          ),


          // حقل إرسال الرسالة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // زر الملفات (اختياري)
                  IconButton(
                    icon: const Icon(Icons.attach_file,color: Colors.black),
                    onPressed: () {
                      // يمكنك إضافة وظيفة إرسال ملفات هنا
                    },
                  ),
                  // حقل الإدخال
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // زر الإرسال
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(Message msg) {
    final bool isMe = msg.isOwnMessage;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المحتوى
            if (msg.messageType == 'text')
              Text(
                msg.content ?? '',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            const SizedBox(height: 4),
            // الوقت
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.formattedTime,
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.black54,
                  ),
                ),
                // علامة القراءة
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.done,
                    color:AppColors.whiteColor,
                    size: 14,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}