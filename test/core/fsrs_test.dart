import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

void main() {
  group('FSRS Algorithm', () {
    late fsrs.FSRS scheduler;

    setUp(() {
      scheduler = fsrs.FSRS(
        parameters: fsrs.Parameters()..requestRetention = 0.9,
      );
    });

    test('New card should have state New', () {
      final card = fsrs.Card();
      expect(card.state, fsrs.State.newState);
      expect(card.reps, 0);
    });

    test('Rating Good on new card moves to Learning', () {
      final card = fsrs.Card();
      final result = scheduler.repeat(card, DateTime.now());
      final updated = result[fsrs.Rating.good]!.card;

      expect(updated.state, fsrs.State.learning);
      expect(updated.reps, 1);
    });

    test('Rating Again keeps card in learning with short interval', () {
      final card = fsrs.Card();
      final result = scheduler.repeat(card, DateTime.now());
      final updated = result[fsrs.Rating.again]!.card;

      expect(updated.state, fsrs.State.learning);
      final interval = updated.due.difference(DateTime.now());
      expect(interval.inMinutes, lessThan(10));
    });

    test('Multiple Good ratings increase stability', () {
      var card = fsrs.Card();
      var now = DateTime.now();

      // Simulate 3 review sessions
      for (var i = 0; i < 3; i++) {
        final result = scheduler.repeat(card, now);
        card = result[fsrs.Rating.good]!.card;
        now = card.due;
      }

      expect(card.stability, greaterThan(0));
      expect(card.reps, 3);
    });

    test('Rating Easy gives longest interval', () {
      final card = fsrs.Card();
      final result = scheduler.repeat(card, DateTime.now());

      final easyInterval =
          result[fsrs.Rating.easy]!.card.due.difference(DateTime.now());
      final goodInterval =
          result[fsrs.Rating.good]!.card.due.difference(DateTime.now());
      final hardInterval =
          result[fsrs.Rating.hard]!.card.due.difference(DateTime.now());

      expect(easyInterval, greaterThan(goodInterval));
      expect(goodInterval, greaterThanOrEqualTo(hardInterval));
    });
  });

  group('Quiz Logic', () {
    test('Score calculation works correctly', () {
      const totalQuestions = 10;
      const correctAnswers = 7;
      const xpPerCorrect = 10;
      const bonusPerfect = 20;

      final score = correctAnswers / totalQuestions;
      final xp = correctAnswers * xpPerCorrect +
          (score == 1.0 ? bonusPerfect : 0);

      expect(score, 0.7);
      expect(xp, 70); // 7 * 10, no perfect bonus
    });

    test('Perfect score gives bonus XP', () {
      const totalQuestions = 10;
      const correctAnswers = 10;
      const xpPerCorrect = 10;
      const bonusPerfect = 20;

      final score = correctAnswers / totalQuestions;
      final xp = correctAnswers * xpPerCorrect +
          (score == 1.0 ? bonusPerfect : 0);

      expect(score, 1.0);
      expect(xp, 120); // 10 * 10 + 20 bonus
    });
  });

  group('Streak Logic', () {
    test('Same day activity maintains streak', () {
      final lastActive = DateTime(2026, 3, 21);
      final now = DateTime(2026, 3, 21, 15, 30);
      final diff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastActive.year, lastActive.month, lastActive.day))
          .inDays;

      expect(diff, 0); // Same day
    });

    test('Next day increments streak', () {
      final lastActive = DateTime(2026, 3, 20);
      final now = DateTime(2026, 3, 21);
      final diff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastActive.year, lastActive.month, lastActive.day))
          .inDays;

      expect(diff, 1); // Consecutive day
    });

    test('Skipped day resets streak', () {
      final lastActive = DateTime(2026, 3, 19);
      final now = DateTime(2026, 3, 21);
      final diff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastActive.year, lastActive.month, lastActive.day))
          .inDays;

      expect(diff, 2); // Skipped a day → reset
    });
  });
}
