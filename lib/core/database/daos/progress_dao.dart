import 'package:drift/drift.dart';

import '../app_database.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [UserProgress, UserStats, QuizResults, Achievements])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  // ─── User Progress (FSRS) ───

  /// Get progress for a specific card
  Future<UserProgressData?> getCardProgress(String cardId) {
    return (select(userProgress)
          ..where((p) => p.cardId.equals(cardId)))
        .getSingleOrNull();
  }

  /// Upsert progress after review
  Future<void> upsertProgress(UserProgressCompanion entry) {
    return into(userProgress).insertOnConflictUpdate(entry);
  }

  /// Watch due count for badge display
  Stream<int> watchDueCount() {
    final now = DateTime.now();
    final query = selectOnly(userProgress)
      ..addColumns([userProgress.id.count()])
      ..where(userProgress.nextReview.isSmallerOrEqualValue(now));
    return query
        .watchSingle()
        .map((row) => row.read(userProgress.id.count()) ?? 0);
  }

  // ─── User Stats ───

  /// Watch current user stats
  Stream<UserStat> watchStats() {
    return (select(userStats)
          ..where((s) => s.id.equals('current')))
        .watchSingle();
  }

  /// Get current stats
  Future<UserStat> getStats() {
    return (select(userStats)
          ..where((s) => s.id.equals('current')))
        .getSingle();
  }

  /// Add XP and update streak
  Future<void> addXp(int xp) async {
    final stats = await getStats();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = stats.currentStreak;
    if (stats.lastActiveDate != null) {
      final lastDate = DateTime(
        stats.lastActiveDate!.year,
        stats.lastActiveDate!.month,
        stats.lastActiveDate!.day,
      );
      final diff = today.difference(lastDate).inDays;
      if (diff == 1) {
        newStreak += 1;
      } else if (diff > 1) {
        newStreak = 1; // Reset streak
      }
      // diff == 0 means same day, keep streak
    } else {
      newStreak = 1;
    }

    final longestStreak =
        newStreak > stats.longestStreak ? newStreak : stats.longestStreak;

    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(
        totalXp: Value(stats.totalXp + xp),
        currentStreak: Value(newStreak),
        longestStreak: Value(longestStreak),
        lastActiveDate: Value(now),
      ),
    );
  }

  /// Decrement hearts
  Future<int> useHeart() async {
    final stats = await getStats();
    final newHearts = (stats.hearts - 1).clamp(0, 5);
    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(hearts: Value(newHearts)),
    );
    return newHearts;
  }

  /// Regenerate hearts (call periodically)
  Future<void> regenerateHearts() async {
    final stats = await getStats();
    if (stats.hearts >= 5) return;

    final now = DateTime.now();
    if (stats.heartsRegenAt != null &&
        now.isAfter(stats.heartsRegenAt!)) {
      final elapsed = now.difference(stats.heartsRegenAt!).inMinutes;
      final heartsToAdd = (elapsed / 30).floor(); // 1 heart per 30 min
      if (heartsToAdd > 0) {
        final newHearts = (stats.hearts + heartsToAdd).clamp(0, 5);
        await (update(userStats)..where((s) => s.id.equals('current'))).write(
          UserStatsCompanion(
            hearts: Value(newHearts),
            heartsRegenAt: Value(now),
          ),
        );
      }
    }
  }

  /// Increment words learned
  Future<void> incrementWordsLearned() async {
    final stats = await getStats();
    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(
        wordsLearned: Value(stats.wordsLearned + 1),
      ),
    );
  }

  // ─── Quiz Results ───

  /// Save quiz result
  Future<void> saveQuizResult(QuizResultsCompanion result) {
    return into(quizResults).insert(result);
  }

  /// Watch recent quiz results
  Stream<List<QuizResult>> watchRecentQuizzes({int limit = 10}) {
    return (select(quizResults)
          ..orderBy([(q) => OrderingTerm.desc(q.completedAt)])
          ..limit(limit))
        .watch();
  }

  // ─── Achievements ───

  /// Unlock achievement
  Future<void> unlockAchievement(AchievementsCompanion achievement) {
    return into(achievements).insertOnConflictUpdate(achievement);
  }

  /// Watch all achievements
  Stream<List<Achievement>> watchAchievements() {
    return select(achievements).watch();
  }
}
