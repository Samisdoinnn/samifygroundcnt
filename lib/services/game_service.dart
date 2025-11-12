import '../models/game_model.dart';

class GameService {
  static final List<TriviaQuestion> triviaQuestions = [
    const TriviaQuestion(
      id: '1',
      question: 'What is the capital of France?',
      options: ['London', 'Berlin', 'Paris', 'Madrid'],
      correctAnswer: 'Paris',
      category: 'Geography',
    ),
    const TriviaQuestion(
      id: '2',
      question: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
      correctAnswer: '4',
      category: 'Math',
    ),
    const TriviaQuestion(
      id: '3',
      question: 'Who wrote Romeo and Juliet?',
      options: [
        'Jane Austen',
        'William Shakespeare',
        'Mark Twain',
        'Agatha Christie',
      ],
      correctAnswer: 'William Shakespeare',
      category: 'Literature',
    ),
    const TriviaQuestion(
      id: '4',
      question: 'What is the largest planet in our solar system?',
      options: ['Saturn', 'Mars', 'Jupiter', 'Neptune'],
      correctAnswer: 'Jupiter',
      category: 'Science',
    ),
    const TriviaQuestion(
      id: '5',
      question: 'In what year did World War II end?',
      options: ['1943', '1944', '1945', '1946'],
      correctAnswer: '1945',
      category: 'History',
    ),
  ];

  static List<TriviaQuestion> getRandomQuestions(int count) {
    final shuffled = List<TriviaQuestion>.from(triviaQuestions)..shuffle();
    return shuffled.take(count).toList();
  }
}


