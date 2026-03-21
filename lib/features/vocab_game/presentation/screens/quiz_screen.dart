import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:uuid/uuid.dart';

import '../../../../core/audio/audio_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/progress_dao.dart';
import '../../../../core/database/database_provider.dart';
import '../../domain/usecases/review_service.dart';
import '../providers/vocab_providers.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String deckId;
  const QuizScreen({super.key, required this.deckId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));
  final _random = Random();
  final _uuid = const Uuid();

  List<VocabCard> _allCards = [];
  List<_QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _answered = false;
  bool _isLoading = true;
  final _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _loadQuiz();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    final cards =
        await ref.read(vocabDaoProvider).watchCardsByDeck(widget.deckId).first;
    _allCards = List.from(cards);

    if (_allCards.length < 4) {
      setState(() => _isLoading = false);
      return;
    }

    final questions = <_QuizQuestion>[];
    final shuffled = List<VocabCard>.from(_allCards)..shuffle(_random);

    for (final card in shuffled.take(10)) {
      // Pick 3 distractors from same deck
      final distractors = _allCards
          .where((c) => c.id != card.id)
          .toList()
        ..shuffle(_random);
      final options = [
        card.english,
        ...distractors.take(3).map((c) => c.english),
      ]..shuffle(_random);

      questions.add(_QuizQuestion(
        card: card,
        options: options,
        correctAnswer: card.english,
      ));
    }

    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _selectAnswer(String answer) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = answer;
      _answered = true;
    });

    final question = _questions[_currentIndex];
    final isCorrect = answer == question.correctAnswer;

    if (isCorrect) {
      _correctCount++;
      _confetti.play();
    }

    // Rate via FSRS
    final reviewService = ref.read(reviewServiceProvider);
    reviewService.reviewCard(
      question.card.id,
      'vocab',
      isCorrect ? fsrs.Rating.good : fsrs.Rating.again,
    );

    // Auto-advance after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = ref.watch(audioServiceProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_allCards.length < 4) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('Need at least 4 cards in the deck for a quiz.'),
        ),
      );
    }

    // Quiz complete
    if (_currentIndex >= _questions.length) {
      _stopwatch.stop();
      final score = _correctCount / _questions.length;
      final xp = _correctCount * AppConstants.xpPerCorrectAnswer +
          (score == 1.0 ? AppConstants.xpBonusPerfectQuiz : 0);

      // Save result
      ProgressDao(ref.read(databaseProvider)).saveQuizResult(
        QuizResultsCompanion.insert(
          id: Value(_uuid.v4()),
          deckId: Value(widget.deckId),
          quizType: 'mcq',
          totalQuestions: _questions.length,
          correctAnswers: _correctCount,
          xpEarned: Value(xp),
          durationSeconds: _stopwatch.elapsed.inSeconds,
        ),
      );

      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                score >= 0.8 ? Icons.emoji_events : Icons.thumb_up,
                size: 72,
                color: score >= 0.8 ? Colors.amber : theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                score == 1.0 ? 'Perfect!' : score >= 0.8 ? 'Great job!' : 'Keep practicing!',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$_correctCount / ${_questions.length} correct',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('+$xp XP', style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${_questions.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'What does this mean?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Tugen word
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        question.card.tugen,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => audioService.play(
                          question.card.audioPath ?? '',
                          remoteUrl: question.card.audioUrl,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Options
                ...question.options.map((option) {
                  Color? bgColor;
                  Color? borderColor;
                  if (_answered) {
                    if (option == question.correctAnswer) {
                      bgColor = Colors.green.withValues(alpha: 0.15);
                      borderColor = Colors.green;
                    } else if (option == _selectedAnswer) {
                      bgColor = Colors.red.withValues(alpha: 0.15);
                      borderColor = Colors.red;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: bgColor,
                        side: BorderSide(
                          color: borderColor ?? theme.colorScheme.outline,
                          width: borderColor != null ? 2 : 1,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _answered ? null : () => _selectAnswer(option),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 15,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizQuestion {
  final VocabCard card;
  final List<String> options;
  final String correctAnswer;

  _QuizQuestion({
    required this.card,
    required this.options,
    required this.correctAnswer,
  });
}
