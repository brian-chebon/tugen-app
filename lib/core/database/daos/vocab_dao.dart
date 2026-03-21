import 'package:drift/drift.dart';

import '../app_database.dart';

part 'vocab_dao.g.dart';

@DriftAccessor(tables: [Decks, VocabCards, UserProgress])
class VocabDao extends DatabaseAccessor<AppDatabase> with _$VocabDaoMixin {
  VocabDao(super.db);

  /// Watch all decks
  Stream<List<Deck>> watchDecks() {
    return select(decks).watch();
  }

  /// Watch cards in a deck
  Stream<List<VocabCard>> watchCardsByDeck(String deckId) {
    return (select(vocabCards)
          ..where((c) => c.deckId.equals(deckId)))
        .watch();
  }

  /// Get cards due for review (FSRS scheduling)
  Future<List<VocabCard>> getDueCards({int limit = 20}) async {
    final now = DateTime.now();
    final dueProgress = await (select(userProgress)
          ..where((p) =>
              p.cardType.equals('vocab') &
              (p.nextReview.isSmallerOrEqualValue(now) |
                  p.nextReview.isNull()))
          ..limit(limit))
        .get();

    if (dueProgress.isEmpty) return [];

    final cardIds = dueProgress.map((p) => p.cardId).toList();
    return (select(vocabCards)
          ..where((c) => c.id.isIn(cardIds)))
        .get();
  }

  /// Get new cards (no progress entry yet)
  Future<List<VocabCard>> getNewCards(String deckId, {int limit = 5}) async {
    // Find cards without progress entries
    final allCards = await (select(vocabCards)
          ..where((c) => c.deckId.equals(deckId)))
        .get();

    final withProgress = await (select(userProgress)
          ..where((p) => p.cardType.equals('vocab')))
        .get();

    final progressCardIds = withProgress.map((p) => p.cardId).toSet();
    return allCards
        .where((c) => !progressCardIds.contains(c.id))
        .take(limit)
        .toList();
  }

  /// Batch insert decks
  Future<void> insertDecks(List<DecksCompanion> items) async {
    await batch((b) => b.insertAllOnConflictUpdate(decks, items));
  }

  /// Batch insert vocab cards
  Future<void> insertVocabCards(List<VocabCardsCompanion> items) async {
    await batch((b) => b.insertAllOnConflictUpdate(vocabCards, items));
  }
}
