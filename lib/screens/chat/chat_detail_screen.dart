import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/message_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/service_providers.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.currentUserId,
    required this.currentUserName,
  });

  final String chatId;
  final String otherUserId;
  final String currentUserId;
  final String currentUserName;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.sendMessage(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      senderName: widget.currentUserName,
      text: text,
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId)),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMine = message.senderId == widget.currentUserId;
                  return _MessageBubble(
                    message: message,
                    isMine: isMine,
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMine,
  });

  final MessageModel message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final alignment =
        isMine ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMine ? Colors.blueAccent : Colors.grey.shade300;
    final textColor = isMine ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              TimeOfDay.fromDateTime(message.timestamp).format(context),
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}


