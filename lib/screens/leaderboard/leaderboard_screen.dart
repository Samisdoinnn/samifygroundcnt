import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/game_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key, this.gameType = 'trivia'});

  final String gameType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardProvider(gameType));

    return Scaffold(
      appBar: AppBar(title: Text('${gameType.toUpperCase()} Leaderboard')),
      body: leaderboard.when(
        data: (scores) {
          if (scores.isEmpty) {
            return const Center(child: Text('No scores yet.'));
          }
          return ListView.separated(
            itemCount: scores.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final score = scores[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(score.userName),
                trailing: Text('${score.score} pts'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}


