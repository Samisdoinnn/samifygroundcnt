import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/game_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';
import '../../services/game_service.dart';

class TriviaGameScreen extends ConsumerStatefulWidget {
  const TriviaGameScreen({super.key});

  @override
  ConsumerState<TriviaGameScreen> createState() => _TriviaGameScreenState();
}

class _TriviaGameScreenState extends ConsumerState<TriviaGameScreen> {
  late List<TriviaQuestion> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    questions = GameService.getRandomQuestions(5);
    currentQuestionIndex = 0;
    score = 0;
    answered = false;
    selectedAnswer = null;
    gameOver = false;
  }

  void _answerQuestion(String answer) {
    if (answered) return;
    final isCorrect = answer == questions[currentQuestionIndex].correctAnswer;
    setState(() {
      selectedAnswer = answer;
      answered = true;
      if (isCorrect) {
        score += 10;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          answered = false;
          selectedAnswer = null;
        });
      } else {
        _endGame();
      }
    });
  }

  Future<void> _endGame() async {
    setState(() => gameOver = true);
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.saveGameScore(
      userId: user.id,
      userName: user.name,
      score: score,
      gameType: 'trivia',
    );
    ref.read(currentUserDataProvider.notifier).updateCoins(user.coins + (score ~/ 10));
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game Over!',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Score: $score',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () {
                    setState(_startGame);
                  },
                  child: const Text('Play Again'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}/${questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Score: $score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion.question,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final option = currentQuestion.options[index];
                  final isCorrect =
                      option == currentQuestion.correctAnswer;
                  final isSelected = option == selectedAnswer;

                  Color backgroundColor = Colors.grey.shade300;
                  if (answered) {
                    if (isCorrect) {
                      backgroundColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red;
                    }
                  }

                  return GestureDetector(
                    onTap: answered ? null : () => _answerQuestion(option),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: answered ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


