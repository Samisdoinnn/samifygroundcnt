import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'service_providers.dart';

final userProvider =
    FutureProvider.family<UserModel?, String>((ref, userId) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getUser(userId);
});

final followersProvider =
    FutureProvider.family<List<UserModel>, List<String>>((ref, userIds) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final users = await Future.wait(
    userIds.map((id) async => firestore.getUser(id)),
  );
  return users.whereType<UserModel>().toList();
});


