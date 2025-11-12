import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';
import '../../services/storage_service.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isSubmitting = false;
  String? _imageUrl;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final user = ref.read(currentUserDataProvider);
    if (user == null) return;
    final storage = ref.read(storageServiceProvider);
    final url = await storage.uploadPostImage(user.id);
    if (url != null) {
      setState(() {
        _imageUrl = url;
      });
    }
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserDataProvider);
    if (user == null || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image required to create post')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.createPost(
      authorId: user.id,
      authorName: user.name,
      authorPhotoUrl: user.photoUrl,
      caption: _captionController.text.trim(),
      imageUrl: _imageUrl!,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDataProvider);
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
                    ? Text(user.name.isNotEmpty ? user.name[0] : 'U')
                    : null,
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share something exciting...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imageUrl!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Add Photo'),
                  ),
                ),
              ),
            if (_imageUrl != null)
              TextButton(
                onPressed: _pickImage,
                child: const Text('Change Photo'),
              ),
          ],
        ),
      ),
    );
  }
}


