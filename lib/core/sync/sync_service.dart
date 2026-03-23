import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../auth/auth_provider.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final user = ref.watch(currentUserProvider);
  return SyncService(db, user?.uid);
});

/// Connectivity stream
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

class SyncService {
  final AppDatabase _db;
  final String? _userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _log = Logger();

  SyncService(this._db, this._userId);

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
    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection(item.entityType)
        .doc(item.entityId);

    switch (item.action) {
      case 'create':
      case 'update':
        await docRef.set({
          ...payload,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        break;
      case 'delete':
        await docRef.delete();
        break;
    }
  }

  /// Pull latest content from Firestore → local DB
  Future<void> pullContent() async {
    if (!_canSync) return;

    try {
      // Pull categories
      final catSnap =
          await _firestore.collection('categories').get();
      final cats = catSnap.docs.map((doc) {
        final d = doc.data();
        return CategoriesCompanion.insert(
          id: doc.id,
          nameEn: d['nameEn'] ?? '',
          nameSw: d['nameSw'] ?? '',
          nameTug: d['nameTug'] ?? '',
          icon: Value(d['icon'] ?? '📚'),
          sortOrder: Value(d['sortOrder'] ?? 0),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.categories, cats);
      });

      // Pull phrases
      final phraseSnap =
          await _firestore.collection('phrases').get();
      final phrases = phraseSnap.docs.map((doc) {
        final d = doc.data();
        return PhrasesCompanion.insert(
          id: doc.id,
          categoryId: d['categoryId'] ?? '',
          tugen: d['tugen'] ?? '',
          english: d['english'] ?? '',
          swahili: d['swahili'] ?? '',
          pronunciation: Value(d['pronunciation']),
          audioUrl: Value(d['audioUrl']),
          difficulty: Value(d['difficulty'] ?? 1),
          notes: Value(d['notes']),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.phrases, phrases);
      });

      // Pull decks & vocab cards
      final deckSnap = await _firestore.collection('decks').get();
      final decks = deckSnap.docs.map((doc) {
        final d = doc.data();
        return DecksCompanion.insert(
          id: doc.id,
          nameEn: d['nameEn'] ?? '',
          nameSw: d['nameSw'] ?? '',
          nameTug: d['nameTug'] ?? '',
          description: Value(d['description']),
          icon: Value(d['icon'] ?? '🃏'),
          totalCards: Value(d['totalCards'] ?? 0),
          isPremium: Value(d['isPremium'] ?? false),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.decks, decks);
      });

      // Pull stories
      final storySnap =
          await _firestore.collection('stories').get();
      final stories = storySnap.docs.map((doc) {
        final d = doc.data();
        return StoriesCompanion.insert(
          id: doc.id,
          titleEn: d['titleEn'] ?? '',
          titleSw: d['titleSw'] ?? '',
          titleTug: d['titleTug'] ?? '',
          description: Value(d['description']),
          audioUrl: Value(d['audioUrl']),
          durationSeconds: Value(d['durationSeconds'] ?? 0),
          difficulty: Value(d['difficulty'] ?? 'beginner'),
          coverImageUrl: Value(d['coverImageUrl']),
        );
      }).toList();

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.stories, stories);
      });

      _log.i('Content sync completed');
    } catch (e) {
      _log.e('Content pull failed', error: e);
    }
  }

  /// Pull user progress from Firestore → local
  Future<void> pullUserProgress() async {
    if (!_canSync) return;

    try {
      final progressSnap = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .get();

      final progress = progressSnap.docs.map((doc) {
        final d = doc.data();
        return UserProgressCompanion.insert(
          id: doc.id,
          cardId: d['cardId'] ?? '',
          cardType: d['cardType'] ?? 'vocab',
          stability: Value(
              (d['stability'] as num?)?.toDouble() ?? 0.0),
          difficulty: Value(
              (d['difficulty'] as num?)?.toDouble() ?? 0.3),
          reps: Value(d['reps'] ?? 0),
          lapses: Value(d['lapses'] ?? 0),
          state: Value(d['state'] ?? 0),
          lastReview: Value(d['lastReview'] != null
              ? (d['lastReview'] as Timestamp).toDate()
              : null),
          nextReview: Value(d['nextReview'] != null
              ? (d['nextReview'] as Timestamp).toDate()
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
