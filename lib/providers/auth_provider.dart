import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'service_providers.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value != null;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  final firebaseUser = authService.getCurrentUser();
  if (firebaseUser == null) return null;
  return firestore.getUser(firebaseUser.uid);
});

final currentUserDataProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  CurrentUserNotifier(this._ref) : super(null);

  final Ref _ref;

  Future<void> refresh() async {
    final user = await _ref.read(currentUserProvider.future);
    state = user;
  }

  void setCurrentUser(UserModel? user) {
    state = user;
  }

  void updateCoins(int coins) {
    if (state == null) return;
    state = state!.copyWith(coins: coins);
  }
}


