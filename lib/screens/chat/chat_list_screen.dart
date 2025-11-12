import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('💬 Messages')),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Login to start chatting.'));
          }
          final chatList = ref.watch(chatListProvider(user.id));
          return chatList.when(
            data: (chats) {
              if (chats.isEmpty) {
                return const Center(child: Text('No messages yet'));
              }
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final participants =
                      List<String>.from(chat['participants'] as List<dynamic>);
                  final otherUserId =
                      participants.firstWhere((id) => id != user.id);
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(otherUserId.isNotEmpty
                          ? otherUserId[0].toUpperCase()
                          : '?'),
                    ),
                    title: Text(otherUserId),
                    subtitle: Text(
                      (chat['lastMessage'] as String?) ?? 'No messages yet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            chatId: chat['chatId'] as String? ?? '',
                            otherUserId: otherUserId,
                            currentUserId: user.id,
                            currentUserName: user.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            error: (error, _) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}


