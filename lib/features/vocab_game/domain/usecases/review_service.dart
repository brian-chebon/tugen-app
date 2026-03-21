import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/daos/progress_dao.dart';
import '../../core/sync/sync_service.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final db = ref.watch(databaseProvider);
  final syncService = ref.watch(syncServiceProvider);
  return ReviewService(ProgressDao(db), syncService);
});

/// Wraps the FSRS algorithm to manage card scheduling
class ReviewService {
  final ProgressDao _dao;
  final SyncService _syncService;
  final fsrs.FSRS _fsrs;
  final _uuid = const Uuid();

  ReviewService(this._dao, this._syncService)
      : _fsrs = fsrs.FSRS(
          parameters: fsrs.Parameters()
            ..requestRetention = AppConstants.desiredRetention,
        );

  /// Review a card and update its schedule
  Future<UserProgressData> reviewCard(
    String cardId,
    String cardType,
    fsrs.Rating rating,
  ) async {
    // Get or create progress
    var progress = await _dao.getCardProgress(cardId);
    fsrs.Card card;

    if (progress != null) {
      card = fsrs.Card()
        ..stability = progress.stability
        ..difficulty = progress.difficulty
        ..reps = progress.reps
        ..lapses = progress.lapses
        ..state = fsrs.State.values[progress.state]
        ..lastReview = progress.lastReview
        ..due = progress.nextReview ?? DateTime.now();
    } else {
      card = fsrs.Card();
    }

    // Schedule with FSRS
    final result = _fsrs.repeat(card, DateTime.now());
    final scheduled = result[rating]!;
    final updatedCard = scheduled.card;

    final id = progress?.id ?? _uuid.v4();
    final entry = UserProgressCompanion(
      id: Value(id),
      cardId: Value(cardId),
      cardType: Value(cardType),
      stability: Value(updatedCard.stability),
      difficulty: Value(updatedCard.difficulty),
      reps: Value(updatedCard.reps),
      lapses: Value(updatedCard.lapses),
      state: Value(updatedCard.state.index),
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
        'reps': updatedCard.reps,
        'lapses': updatedCard.lapses,
        'state': updatedCard.state.index,
        'lastReview': DateTime.now().toIso8601String(),
        'nextReview': updatedCard.due.toIso8601String(),
      },
    );

    // Track XP
    if (rating != fsrs.Rating.again) {
      await _dao.addXp(AppConstants.xpPerCorrectAnswer);
    }

    // Check if this is a newly learned word
    if (progress == null ||
        (progress.state == 0 && updatedCard.state.index > 0)) {
      await _dao.incrementWordsLearned();
    }

    return (await _dao.getCardProgress(cardId))!;
  }

  /// Get preview of next review intervals for all ratings
  Map<fsrs.Rating, Duration> getIntervalPreview(
      UserProgressData? progress) {
    fsrs.Card card;
    if (progress != null) {
      card = fsrs.Card()
        ..stability = progress.stability
        ..difficulty = progress.difficulty
        ..reps = progress.reps
        ..lapses = progress.lapses
        ..state = fsrs.State.values[progress.state]
        ..lastReview = progress.lastReview
        ..due = progress.nextReview ?? DateTime.now();
    } else {
      card = fsrs.Card();
    }

    final result = _fsrs.repeat(card, DateTime.now());
    return {
      for (final rating in fsrs.Rating.values)
        rating: result[rating]!.card.due.difference(DateTime.now()),
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
