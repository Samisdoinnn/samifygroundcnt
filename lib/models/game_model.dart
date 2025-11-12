class TriviaQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String category;

  const TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.category,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: List<String>.from(json['options'] ?? const []),
      correctAnswer: json['correctAnswer'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class GameScore {
  final String id;
  final String userId;
  final String userName;
  final int score;
  final String gameType;
  final DateTime createdAt;

  const GameScore({
    required this.id,
    required this.userId,
    required this.userName,
    required this.score,
    required this.gameType,
    required this.createdAt,
  });

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      gameType: json['gameType'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'score': score,
      'gameType': gameType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}


