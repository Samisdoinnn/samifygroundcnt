import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../services/firestore_service.dart';
import 'service_providers.dart';

final feedPostsProvider = StreamProvider<List<PostModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getFeedPosts();
});

final postLikeProvider = StateNotifierProvider.family<PostLikeNotifier, bool,
    PostLikeParams>((ref, params) {
  final firestore = ref.watch(firestoreServiceProvider);
  return PostLikeNotifier(firestore, params);
});

class PostLikeParams {
  const PostLikeParams({
    required this.postId,
    required this.initiallyLiked,
  });

  final String postId;
  final bool initiallyLiked;
}

class PostLikeNotifier extends StateNotifier<bool> {
  PostLikeNotifier(this._firestoreService, PostLikeParams params)
      : _postId = params.postId,
        super(params.initiallyLiked);

  final FirestoreService _firestoreService;
  final String _postId;

  Future<void> toggleLike(String userId) async {
    final shouldLike = !state;
    state = shouldLike;
    if (shouldLike) {
      await _firestoreService.likePost(_postId, userId);
    } else {
      await _firestoreService.unlikePost(_postId, userId);
    }
  }
}


