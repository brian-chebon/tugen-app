import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../../constants/app_constants.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [UserProgress, UserStats, QuizResults, Achievements])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  static const _uuid = Uuid();

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

    // Check streak achievements
    await _checkStreakAchievements(newStreak);
  }

  /// Decrement hearts, returns remaining count
  Future<int> useHeart() async {
    final stats = await getStats();
    if (stats.hearts <= 0) return 0;

    final newHearts = (stats.hearts - 1).clamp(0, 5);
    final now = DateTime.now();

    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(
        hearts: Value(newHearts),
        // Start regen timer if this is the first heart lost
        heartsRegenAt: Value(
          stats.heartsRegenAt ?? now,
        ),
      ),
    );
    return newHearts;
  }

  /// Check if user has hearts available
  Future<bool> hasHearts() async {
    await regenerateHearts();
    final stats = await getStats();
    return stats.hearts > 0;
  }

  /// Regenerate hearts (call periodically)
  Future<void> regenerateHearts() async {
    final stats = await getStats();
    if (stats.hearts >= AppConstants.maxHearts) return;

    final now = DateTime.now();
    final regenAt = stats.heartsRegenAt ?? now;

    if (now.isAfter(regenAt)) {
      final elapsed = now.difference(regenAt).inMinutes;
      final heartsToAdd =
          (elapsed / AppConstants.heartRegenMinutes).floor();
      if (heartsToAdd > 0) {
        final newHearts =
            (stats.hearts + heartsToAdd).clamp(0, AppConstants.maxHearts);
        await (update(userStats)..where((s) => s.id.equals('current')))
            .write(
          UserStatsCompanion(
            hearts: Value(newHearts),
            heartsRegenAt: Value(
              newHearts >= AppConstants.maxHearts ? null : now,
            ),
          ),
        );
      }
    }
  }

  /// Increment words learned
  Future<void> incrementWordsLearned() async {
    final stats = await getStats();
    final newCount = stats.wordsLearned + 1;
    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(
        wordsLearned: Value(newCount),
      ),
    );

    // Check word count achievements
    await _checkWordAchievements(newCount);
  }

  /// Increment quizzes completed
  Future<void> incrementQuizzesCompleted() async {
    final stats = await getStats();
    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(
        quizzesCompleted: Value(stats.quizzesCompleted + 1),
      ),
    );
  }

  /// Increment stories completed
  Future<void> incrementStoriesCompleted() async {
    final stats = await getStats();
    final newCount = stats.storiesCompleted + 1;
    await (update(userStats)..where((s) => s.id.equals('current'))).write(
      UserStatsCompanion(
        storiesCompleted: Value(newCount),
      ),
    );

    // Check story achievements
    await _checkStoryAchievements(newCount);
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

  /// Unlock achievement (idempotent — won't duplicate)
  Future<void> unlockAchievement(AchievementsCompanion achievement) {
    return into(achievements).insertOnConflictUpdate(achievement);
  }

  /// Watch all achievements
  Stream<List<Achievement>> watchAchievements() {
    return select(achievements).watch();
  }

  /// Check if an achievement is already unlocked
  Future<bool> _isUnlocked(String badgeId) async {
    final existing = await (select(achievements)
          ..where((a) => a.badgeId.equals(badgeId)))
        .getSingleOrNull();
    return existing != null;
  }

  // ─── Achievement Checking Logic ───

  Future<void> _checkStreakAchievements(int currentStreak) async {
    final checks = {
      7: (AppConstants.badge7DayStreak, '7-Day Streak', 'Practiced 7 days in a row'),
      30: (AppConstants.badge30DayStreak, '30-Day Streak', 'Practiced 30 days in a row'),
      100: (AppConstants.badge100DayStreak, '100-Day Streak', 'Practiced 100 days in a row'),
    };

    for (final entry in checks.entries) {
      if (currentStreak >= entry.key) {
        final (badgeId, title, desc) = entry.value;
        if (!await _isUnlocked(badgeId)) {
          await unlockAchievement(AchievementsCompanion.insert(
            id: _uuid.v4(),
            badgeId: badgeId,
            title: title,
            description: desc,
          ));
        }
      }
    }
  }

  Future<void> _checkWordAchievements(int wordsLearned) async {
    final checks = {
      50: (AppConstants.badge50Words, '50 Words', 'Learned 50 Tugen words'),
      200: (AppConstants.badge200Words, '200 Words', 'Learned 200 Tugen words'),
      500: (AppConstants.badge500Words, '500 Words', 'Learned 500 Tugen words'),
    };

    for (final entry in checks.entries) {
      if (wordsLearned >= entry.key) {
        final (badgeId, title, desc) = entry.value;
        if (!await _isUnlocked(badgeId)) {
          await unlockAchievement(AchievementsCompanion.insert(
            id: _uuid.v4(),
            badgeId: badgeId,
            title: title,
            description: desc,
          ));
        }
      }
    }
  }

  Future<void> _checkStoryAchievements(int storiesCompleted) async {
    if (storiesCompleted >= 1) {
      if (!await _isUnlocked(AppConstants.badgeFirstStory)) {
        await unlockAchievement(AchievementsCompanion.insert(
          id: _uuid.v4(),
          badgeId: AppConstants.badgeFirstStory,
          title: 'First Story',
          description: 'Completed your first Tugen story',
        ));
      }
    }
    if (storiesCompleted >= 10) {
      if (!await _isUnlocked(AppConstants.badge10Stories)) {
        await unlockAchievement(AchievementsCompanion.insert(
          id: _uuid.v4(),
          badgeId: AppConstants.badge10Stories,
          title: '10 Stories',
          description: 'Completed 10 Tugen stories',
        ));
      }
    }
  }

  Future<void> checkPerfectQuizAchievement() async {
    if (!await _isUnlocked(AppConstants.badgePerfectQuiz)) {
      await unlockAchievement(AchievementsCompanion.insert(
        id: _uuid.v4(),
        badgeId: AppConstants.badgePerfectQuiz,
        title: 'Perfect Quiz',
        description: 'Scored 100% on a quiz',
      ));
    }
  }
}
