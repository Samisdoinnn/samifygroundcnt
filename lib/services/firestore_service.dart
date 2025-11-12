import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game_model.dart';
import '../models/message_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data()!..putIfAbsent('id', () => doc.id);
      return UserModel.fromJson(data);
    } catch (e) {
      // ignore: avoid_print
      print('Get user error: $e');
      return null;
    }
  }

  Future<void> updateUser(String userId, UserModel user) async {
    try {
      await _firestore.collection('users').doc(userId).update(user.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('Update user error: $e');
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    final batch = _firestore.batch();
    final currentUserRef = _firestore.collection('users').doc(currentUserId);
    final targetUserRef = _firestore.collection('users').doc(targetUserId);

    batch.update(currentUserRef, {
      'following': FieldValue.arrayUnion([targetUserId]),
      'followingCount': FieldValue.increment(1),
    });

    batch.update(targetUserRef, {
      'followers': FieldValue.arrayUnion([currentUserId]),
      'followersCount': FieldValue.increment(1),
    });

    try {
      await batch.commit();
    } catch (e) {
      // ignore: avoid_print
      print('Follow user error: $e');
    }
  }

  Future<String?> createPost({
    required String authorId,
    required String authorName,
    required String? authorPhotoUrl,
    required String caption,
    required String imageUrl,
  }) async {
    try {
      final docRef = await _firestore.collection('posts').add({
        'authorId': authorId,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'caption': caption,
        'imageUrl': imageUrl,
        'likes': <String>[],
        'commentsCount': 0,
        'createdAt': Timestamp.now(),
      });
      return docRef.id;
    } catch (e) {
      // ignore: avoid_print
      print('Create post error: $e');
      return null;
    }
  }

  Stream<List<PostModel>> getFeedPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data()..putIfAbsent('id', () => doc.id);
        return PostModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Like post error: $e');
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Unlike post error: $e');
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    try {
      await chatRef.collection('messages').add({
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'timestamp': Timestamp.now(),
        'isRead': false,
      });
      await chatRef.update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Send message error: $e');
    }
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data()..putIfAbsent('id', () => doc.id);
        return MessageModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getChatList(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['chatId'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> saveGameScore({
    required String userId,
    required String userName,
    required int score,
    required String gameType,
  }) async {
    try {
      await _firestore.collection('game_scores').add({
        'userId': userId,
        'userName': userName,
        'score': score,
        'gameType': gameType,
        'createdAt': Timestamp.now(),
      });
      await _firestore.collection('users').doc(userId).update({
        'coins': FieldValue.increment((score / 10).round()),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Save game score error: $e');
    }
  }

  Stream<List<GameScore>> getLeaderboard(String gameType) {
    return _firestore
        .collection('game_scores')
        .where('gameType', isEqualTo: gameType)
        .orderBy('score', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data()..putIfAbsent('id', () => doc.id);
        return GameScore.fromJson(data);
      }).toList();
    });
  }

  Future<String?> getOrCreateChat(String user1Id, String user2Id) async {
    try {
      final query = await _firestore
          .collection('chats')
          .where('participants', arrayContains: user1Id)
          .get();
      for (final doc in query.docs) {
        final participants = List<String>.from(doc['participants']);
        if (participants.contains(user2Id)) {
          return doc.id;
        }
      }
      final chatRef = await _firestore.collection('chats').add({
        'participants': [user1Id, user2Id],
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'createdAt': Timestamp.now(),
      });
      return chatRef.id;
    } catch (e) {
      // ignore: avoid_print
      print('Get or create chat error: $e');
      return null;
    }
  }
}


