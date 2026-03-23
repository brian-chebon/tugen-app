import 'package:drift/drift.dart';

import '../app_database.dart';

part 'phrases_dao.g.dart';

@DriftAccessor(tables: [Phrases, Categories, Bookmarks])
class PhrasesDao extends DatabaseAccessor<AppDatabase>
    with _$PhrasesDaoMixin {
  PhrasesDao(super.db);

  /// Watch all categories ordered
  Stream<List<Category>> watchCategories() {
    return (select(categories)
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch();
  }

  /// Watch phrases in a category
  Stream<List<Phrase>> watchPhrasesByCategory(String categoryId) {
    return (select(phrases)
          ..where((p) => p.categoryId.equals(categoryId))
          ..orderBy([(p) => OrderingTerm.asc(p.difficulty)]))
        .watch();
  }

  /// Get single phrase
  Future<Phrase?> getPhrase(String id) {
    return (select(phrases)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  /// Search phrases across all languages
  Stream<List<Phrase>> searchPhrases(String query) {
    final pattern = '%$query%';
    return (select(phrases)
          ..where((p) =>
              p.tugen.like(pattern) |
              p.english.like(pattern) |
              p.swahili.like(pattern)))
        .watch();
  }

  /// Watch bookmarked phrases
  Stream<List<Phrase>> watchBookmarkedPhrases() {
    final query = select(phrases).join([
      innerJoin(bookmarks, bookmarks.phraseId.equalsExp(phrases.id)),
    ]);
    return query.watch().map(
          (rows) => rows.map((row) => row.readTable(phrases)).toList(),
        );
  }

  /// Toggle bookmark
  Future<void> toggleBookmark(String phraseId) async {
    final existing = await (select(bookmarks)
          ..where((b) => b.phraseId.equals(phraseId)))
        .getSingleOrNull();

    if (existing != null) {
      await (delete(bookmarks)
            ..where((b) => b.phraseId.equals(phraseId)))
          .go();
    } else {
      await into(bookmarks).insert(
        BookmarksCompanion.insert(
          id: phraseId,
          phraseId: phraseId,
        ),
      );
    }
  }

  /// Check if phrase is bookmarked
  Stream<bool> watchIsBookmarked(String phraseId) {
    return (select(bookmarks)
          ..where((b) => b.phraseId.equals(phraseId)))
        .watch()
        .map((list) => list.isNotEmpty);
  }

  /// Mark phrase audio as downloaded
  Future<void> markDownloaded(String phraseId, String localPath) {
    return (update(phrases)..where((p) => p.id.equals(phraseId))).write(
      PhrasesCompanion(
        isDownloaded: const Value(true),
        audioPath: Value(localPath),
      ),
    );
  }

  /// Batch insert phrases (for initial sync)
  Future<void> insertPhrases(List<PhrasesCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(phrases, items);
    });
  }

  /// Batch insert categories
  Future<void> insertCategories(List<CategoriesCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(categories, items);
    });
  }
}
