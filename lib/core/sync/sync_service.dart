import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../auth/auth_provider.dart';
import '../supabase/supabase_provider.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final user = ref.watch(currentUserProvider);
  final supabase = ref.watch(supabaseClientProvider);
  return SyncService(db, user?.uid, supabase);
});

/// Connectivity stream
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Triggers a one-time content pull on app startup.
/// Watch this in your root widget to ensure content is synced.
final initialSyncProvider = FutureProvider<void>((ref) async {
  final sync = ref.read(syncServiceProvider);
  await sync.pullContent();
});

class SyncService {
  final AppDatabase _db;
  final String? _userId;
  final SupabaseClient _supabase;
  final Logger _log = Logger();

  SyncService(this._db, this._userId, this._supabase);

  bool get _canSync => _userId?.isNotEmpty ?? false;

  /// Enqueue an action for later sync
  Future<void> enqueue({
    required String action,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    await _db.into(_db.syncQueue).insert(
          SyncQueueCompanion.insert(
            action: action,
            entityType: entityType,
            entityId: entityId,
            payload: jsonEncode(payload),
          ),
        );
  }

  /// Process all pending sync items
  Future<void> processQueue() async {
    if (!_canSync) return;

    final pending = await (_db.select(_db.syncQueue)
          ..where((q) => q.status.equals('pending'))
          ..orderBy([(q) => OrderingTerm.asc(q.createdAt)])
          ..limit(50))
        .get();

    for (final item in pending) {
      try {
        await _syncItem(item);
        // Mark as synced
        await (_db.delete(_db.syncQueue)
              ..where((q) => q.id.equals(item.id)))
            .go();
      } catch (e) {
        _log.w('Sync failed for ${item.entityType}/${item.entityId}', error: e);
        // Increment retry count
        await (_db.update(_db.syncQueue)
              ..where((q) => q.id.equals(item.id)))
            .write(
          SyncQueueCompanion(
            retryCount: Value(item.retryCount + 1),
            status: Value(item.retryCount >= 3 ? 'failed' : 'pending'),
          ),
        );
      }
    }
  }

  Future<void> _syncItem(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    // User data is stored in tables prefixed with user_ (e.g., user_progress)
    final table = 'user_${item.entityType}';

    switch (item.action) {
      case 'create':
      case 'update':
        await _supabase.from(table).upsert({
          ...payload,
          'id': item.entityId,
          'user_id': _userId,
          'updated_at': DateTime.now().toIso8601String(),
        });
        break;
      case 'delete':
        await _supabase
            .from(table)
            .delete()
            .eq('id', item.entityId)
            .eq('user_id', _userId!);
        break;
    }
  }

  /// Pull latest content from Supabase → local DB
  Future<void> pullContent() async {
    try {
      // Pull categories
      final cats = await _supabase.from('categories').select();
      final catCompanions = cats.map((d) {
        return CategoriesCompanion.insert(
          id: d['id'] as String,
          nameEn: d['name_en'] ?? '',
          nameSw: d['name_sw'] ?? '',
          nameTug: d['name_tug'] ?? '',
          icon: Value(d['icon'] ?? '\u{1F4DA}'),
          sortOrder: Value(d['sort_order'] ?? 0),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.categories, catCompanions);
      });

      // Pull phrases
      final phraseRows = await _supabase.from('phrases').select();
      final phrases = phraseRows.map((d) {
        return PhrasesCompanion.insert(
          id: d['id'] as String,
          categoryId: d['category_id'] ?? '',
          tugen: d['tugen'] ?? '',
          english: d['english'] ?? '',
          swahili: d['swahili'] ?? '',
          pronunciation: Value(d['pronunciation']),
          audioUrl: Value(d['audio_url']),
          difficulty: Value(d['difficulty'] ?? 1),
          notes: Value(d['notes']),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.phrases, phrases);
      });

      // Pull decks
      final deckRows = await _supabase.from('decks').select();
      final decks = deckRows.map((d) {
        return DecksCompanion.insert(
          id: d['id'] as String,
          nameEn: d['name_en'] ?? '',
          nameSw: d['name_sw'] ?? '',
          nameTug: d['name_tug'] ?? '',
          description: Value(d['description']),
          icon: Value(d['icon'] ?? '\u{1F0CF}'),
          totalCards: Value(d['total_cards'] ?? 0),
          isPremium: Value(d['is_premium'] ?? false),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.decks, decks);
      });

      // Pull vocab cards
      final vocabRows = await _supabase.from('vocab_cards').select();
      final vocabCards = vocabRows.map((d) {
        return VocabCardsCompanion.insert(
          id: d['id'] as String,
          deckId: d['deck_id'] ?? '',
          tugen: d['tugen'] ?? '',
          english: d['english'] ?? '',
          swahili: d['swahili'] ?? '',
          audioUrl: Value(d['audio_url']),
          imagePath: Value(d['image_path']),
          difficulty: Value(d['difficulty'] ?? 1),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.vocabCards, vocabCards);
      });

      // Pull stories
      final storyRows = await _supabase.from('stories').select();
      final stories = storyRows.map((d) {
        return StoriesCompanion.insert(
          id: d['id'] as String,
          titleEn: d['title_en'] ?? '',
          titleSw: d['title_sw'] ?? '',
          titleTug: d['title_tug'] ?? '',
          description: Value(d['description']),
          audioUrl: Value(d['audio_url']),
          durationSeconds: Value(d['duration_seconds'] ?? 0),
          difficulty: Value(d['difficulty'] ?? 'beginner'),
          coverImageUrl: Value(d['cover_image_url']),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.stories, stories);
      });

      // Pull story segments
      final segRows = await _supabase.from('story_segments').select();
      final segments = segRows.map((d) {
        return StorySegmentsCompanion.insert(
          id: d['id'] as String,
          storyId: d['story_id'] ?? '',
          startMs: d['start_ms'] ?? 0,
          endMs: d['end_ms'] ?? 0,
          tugen: d['tugen'] ?? '',
          english: d['english'] ?? '',
          swahili: d['swahili'] ?? '',
          sortOrder: d['sort_order'] ?? 0,
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.storySegments, segments);
      });

      _log.i('Content sync completed');
    } catch (e) {
      _log.e('Content pull failed', error: e);
    }
  }

  /// Pull user progress from Supabase → local
  Future<void> pullUserProgress() async {
    if (!_canSync) return;

    try {
      final progressRows = await _supabase
          .from('user_progress')
          .select()
          .eq('user_id', _userId!);

      final progress = progressRows.map((d) {
        return UserProgressCompanion.insert(
          id: d['id'] as String,
          cardId: d['card_id'] ?? '',
          cardType: d['card_type'] ?? 'vocab',
          stability: Value(
              (d['stability'] as num?)?.toDouble() ?? 0.0),
          difficulty: Value(
              (d['difficulty'] as num?)?.toDouble() ?? 0.3),
          reps: Value(d['reps'] ?? 0),
          lapses: Value(d['lapses'] ?? 0),
          state: Value(d['state'] ?? 0),
          lastReview: Value(d['last_review'] != null
              ? DateTime.parse(d['last_review'] as String)
              : null),
          nextReview: Value(d['next_review'] != null
              ? DateTime.parse(d['next_review'] as String)
              : null),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.userProgress, progress);
      });
    } catch (e) {
      _log.e('User progress pull failed', error: e);
    }
  }
}
