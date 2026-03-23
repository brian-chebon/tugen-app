import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/daos/progress_dao.dart';
import '../../../../core/sync/sync_service.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final db = ref.watch(databaseProvider);
  final syncService = ref.watch(syncServiceProvider);
  return ReviewService(ProgressDao(db), syncService);
});

/// Wraps the FSRS algorithm to manage card scheduling
class ReviewService {
  final ProgressDao _dao;
  final SyncService _syncService;
  final fsrs.Scheduler _scheduler;
  final _uuid = const Uuid();

  ReviewService(this._dao, this._syncService)
      : _scheduler = fsrs.Scheduler(
          desiredRetention: AppConstants.desiredRetention,
        );

  /// Map DB state int to fsrs.State
  static fsrs.State _mapState(int dbState) {
    if (dbState <= 1) return fsrs.State.learning;
    return fsrs.State.fromValue(dbState);
  }

  /// Create an fsrs.Card from existing progress data
  fsrs.Card _createCard(UserProgressData? progress, {String? cardId}) {
    if (progress != null) {
      return fsrs.Card(
        cardId: progress.id.hashCode,
        stability: progress.stability,
        difficulty: progress.difficulty,
        state: _mapState(progress.state),
        lastReview: progress.lastReview?.toUtc(),
        due: progress.nextReview?.toUtc() ?? DateTime.now().toUtc(),
      );
    }
    return fsrs.Card(cardId: (cardId ?? _uuid.v4()).hashCode);
  }

  /// Review a card and update its schedule
  Future<UserProgressData> reviewCard(
    String cardId,
    String cardType,
    fsrs.Rating rating,
  ) async {
    // Get or create progress
    var progress = await _dao.getCardProgress(cardId);
    final card = _createCard(progress, cardId: cardId);

    // Schedule with FSRS
    final now = DateTime.now().toUtc();
    final result = _scheduler.reviewCard(card, rating, reviewDateTime: now);
    final updatedCard = result.card;

    // Track reps/lapses manually since fsrs v2 Card doesn't have them
    final reps = (progress?.reps ?? 0) + 1;
    final lapses = (progress?.lapses ?? 0) + (rating == fsrs.Rating.again ? 1 : 0);

    final id = progress?.id ?? _uuid.v4();
    final entry = UserProgressCompanion(
      id: Value(id),
      cardId: Value(cardId),
      cardType: Value(cardType),
      stability: Value(updatedCard.stability ?? 0.0),
      difficulty: Value(updatedCard.difficulty ?? 0.3),
      reps: Value(reps),
      lapses: Value(lapses),
      state: Value(updatedCard.state.value),
      lastReview: Value(DateTime.now()),
      nextReview: Value(updatedCard.due),
      updatedAt: Value(DateTime.now()),
    );

    await _dao.upsertProgress(entry);

    // Enqueue for sync
    await _syncService.enqueue(
      action: progress != null ? 'update' : 'create',
      entityType: 'progress',
      entityId: id,
      payload: {
        'cardId': cardId,
        'cardType': cardType,
        'stability': updatedCard.stability,
        'difficulty': updatedCard.difficulty,
        'reps': reps,
        'lapses': lapses,
        'state': updatedCard.state.value,
        'lastReview': DateTime.now().toIso8601String(),
        'nextReview': updatedCard.due.toIso8601String(),
      },
    );

    // Track XP
    if (rating != fsrs.Rating.again) {
      await _dao.addXp(AppConstants.xpPerCorrectAnswer);
    }

    // Check if this is a newly learned word (graduated from learning to review)
    if (progress == null ||
        (progress.state <= 1 && updatedCard.state.value >= 2)) {
      await _dao.incrementWordsLearned();
    }

    return (await _dao.getCardProgress(cardId))!;
  }

  /// Get preview of next review intervals for all ratings
  Map<fsrs.Rating, Duration> getIntervalPreview(UserProgressData? progress) {
    final card = _createCard(progress);
    final now = DateTime.now().toUtc();

    return {
      for (final rating in fsrs.Rating.values)
        rating: _scheduler
            .reviewCard(card, rating, reviewDateTime: now)
            .card
            .due
            .difference(now),
    };
  }

  /// Format a duration for display (e.g. "10m", "1d", "3d")
  static String formatInterval(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 30) return '${d.inDays}d';
    return '${(d.inDays / 30).round()}mo';
  }
}
