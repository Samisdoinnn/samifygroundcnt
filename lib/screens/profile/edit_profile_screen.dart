import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';
import '../../services/storage_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  String? _photoUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserDataProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _photoUrl = user?.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final user = ref.read(currentUserDataProvider);
    if (user == null) return;
    final storage = ref.read(storageServiceProvider);
    final newUrl = await storage.uploadProfileImage(user.id);
    if (newUrl != null) {
      setState(() => _photoUrl = newUrl);
    }
  }

  Future<void> _save() async {
    final user = ref.read(currentUserDataProvider);
    if (user == null) return;
    setState(() => _isSaving = true);
    final updatedUser = user.copyWith(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      photoUrl: _photoUrl,
    );
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.updateUser(user.id, updatedUser);
    ref.read(currentUserDataProvider.notifier).setCurrentUser(updatedUser);
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
    }
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
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                  child: _photoUrl == null
                      ? Text(
                          user.name.isNotEmpty ? user.name[0] : 'U',
                        )
                      : null,
                ),
                TextButton(
                  onPressed: _pickPhoto,
                  child: const Text('Change Photo'),
                ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


