import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int coins;
  final DateTime createdAt;
  final List<String> followers;
  final List<String> following;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.coins = 100,
    required this.createdAt,
    this.followers = const [],
    this.following = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      coins: json['coins'] as int? ?? 100,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      followers: List<String>.from(json['followers'] ?? const []),
      following: List<String>.from(json['following'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'coins': coins,
      'createdAt': Timestamp.fromDate(createdAt),
      'followers': followers,
      'following': following,
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? bio,
    int? coins,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      followersCount: followers?.length ?? followersCount,
      followingCount: following?.length ?? followingCount,
      coins: coins ?? this.coins,
      createdAt: createdAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}


