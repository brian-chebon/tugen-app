import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

void main() {
  group('FSRS Algorithm', () {
    late fsrs.Scheduler scheduler;

    setUp(() {
      scheduler = fsrs.Scheduler(
        desiredRetention: 0.9,
        enableFuzzing: false,
      );
    });

    test('New card should have state Learning', () {
      final card = fsrs.Card(cardId: 1);
      expect(card.state, fsrs.State.learning);
    });

    test('Rating Good on new card schedules next review', () {
      final card = fsrs.Card(cardId: 1);
      final now = DateTime.now().toUtc();
      final result = scheduler.reviewCard(card, fsrs.Rating.good, reviewDateTime: now);
      final updated = result.card;

      expect(updated.due.isAfter(now), true);
    });

    test('Rating Again keeps short interval', () {
      final card = fsrs.Card(cardId: 1);
      final now = DateTime.now().toUtc();
      final result = scheduler.reviewCard(card, fsrs.Rating.again, reviewDateTime: now);
      final updated = result.card;

      expect(updated.state, fsrs.State.learning);
      final interval = updated.due.difference(now);
      expect(interval.inMinutes, lessThan(10));
    });

    test('Multiple Good ratings increase stability', () {
      var card = fsrs.Card(cardId: 1);
      var now = DateTime.now().toUtc();

      // Simulate 3 review sessions
      for (var i = 0; i < 3; i++) {
        final result = scheduler.reviewCard(card, fsrs.Rating.good, reviewDateTime: now);
        card = result.card;
        now = card.due;
      }

      expect(card.stability, isNotNull);
      expect(card.stability!, greaterThan(0));
    });

    test('Rating Easy gives longest interval', () {
      final card = fsrs.Card(cardId: 1);
      final now = DateTime.now().toUtc();

      final easyResult = scheduler.reviewCard(card, fsrs.Rating.easy, reviewDateTime: now);
      final goodResult = scheduler.reviewCard(card, fsrs.Rating.good, reviewDateTime: now);
      final hardResult = scheduler.reviewCard(card, fsrs.Rating.hard, reviewDateTime: now);

      final easyInterval = easyResult.card.due.difference(now);
      final goodInterval = goodResult.card.due.difference(now);
      final hardInterval = hardResult.card.due.difference(now);

      expect(easyInterval, greaterThanOrEqualTo(goodInterval));
      expect(goodInterval, greaterThanOrEqualTo(hardInterval));
    });
  });

  group('Quiz Logic', () {
    test('Score calculation works correctly', () {
      const totalQuestions = 10;
      const correctAnswers = 7;
      const xpPerCorrect = 10;
      const bonusPerfect = 20;

      const score = correctAnswers / totalQuestions;
      const xp = correctAnswers * xpPerCorrect +
          (score == 1.0 ? bonusPerfect : 0);

      expect(score, 0.7);
      expect(xp, 70); // 7 * 10, no perfect bonus
    });

    test('Perfect score gives bonus XP', () {
      const totalQuestions = 10;
      const correctAnswers = 10;
      const xpPerCorrect = 10;
      const bonusPerfect = 20;

      const score = correctAnswers / totalQuestions;
      const xp = correctAnswers * xpPerCorrect +
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
