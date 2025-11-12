import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String caption;
  final String imageUrl;
  final List<String> likes;
  final int commentsCount;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.caption,
    required this.imageUrl,
    this.likes = const [],
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorPhotoUrl: json['authorPhotoUrl'] as String?,
      caption: json['caption'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      likes: List<String>.from(json['likes'] ?? const []),
      commentsCount: json['commentsCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'caption': caption,
      'imageUrl': imageUrl,
      'likes': likes,
      'commentsCount': commentsCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}


