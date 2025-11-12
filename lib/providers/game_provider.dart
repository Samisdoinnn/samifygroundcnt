import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_model.dart';
import '../services/firestore_service.dart';
import '../services/game_service.dart';
import 'service_providers.dart';

final leaderboardProvider =
    StreamProvider.family<List<GameScore>, String>((ref, gameType) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getLeaderboard(gameType);
});

final triviaQuestionsProvider =
    StateProvider<List<TriviaQuestion>>((ref) => GameService.getRandomQuestions(5));

final currentTriviaScoreProvider = StateProvider<int>((ref) => 0);


