import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message_model.dart';
import '../services/firestore_service.dart';
import 'service_providers.dart';

final chatListProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getChatList(userId);
});

final messagesProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getMessages(chatId);
});


