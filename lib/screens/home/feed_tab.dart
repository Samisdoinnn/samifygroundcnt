import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes.dart';
import '../../models/post_model.dart';
import '../../providers/post_provider.dart';
import '../../widgets/loading_shimmer.dart';

class FeedTab extends ConsumerWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedPosts = ref.watch(feedPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('🎮 GameVerse Feed')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(Routes.createPost),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Post'),
      ),
      body: feedPosts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet. Be the first!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: posts.length,
            itemBuilder: (context, index) => _PostCard(post: posts[index]),
          );
        },
        loading: () => const LoadingShimmer.list(),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  const _PostCard({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdAt = post.createdAt;
    final timeDisplay =
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.authorPhotoUrl != null
                  ? CachedNetworkImageProvider(post.authorPhotoUrl!)
                  : null,
              child: post.authorPhotoUrl == null
                  ? Text(post.authorName.isNotEmpty
                      ? post.authorName[0]
                      : 'U')
                  : null,
            ),
            title: Text(
              post.authorName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(timeDisplay),
          ),
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(post.caption),
            ),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 4 / 5,
            child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                const SizedBox(width: 4),
                Text('${post.likes.length}'),
                const SizedBox(width: 20),
                const Icon(Icons.chat_bubble_outline, size: 20),
                const SizedBox(width: 4),
                Text('${post.commentsCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


