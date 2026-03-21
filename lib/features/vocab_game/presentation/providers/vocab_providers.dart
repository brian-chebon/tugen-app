import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/daos/vocab_dao.dart';
import '../../../../core/database/daos/progress_dao.dart';

final vocabDaoProvider = Provider<VocabDao>((ref) {
  return VocabDao(ref.watch(databaseProvider));
});

final progressDaoProvider = Provider<ProgressDao>((ref) {
  return ProgressDao(ref.watch(databaseProvider));
});

final decksProvider = StreamProvider<List<Deck>>((ref) {
  return ref.watch(vocabDaoProvider).watchDecks();
});

final cardsByDeckProvider =
    StreamProvider.family<List<VocabCard>, String>((ref, deckId) {
  return ref.watch(vocabDaoProvider).watchCardsByDeck(deckId);
});

final dueCardsProvider = FutureProvider<List<VocabCard>>((ref) {
  return ref.watch(vocabDaoProvider).getDueCards();
});

final userStatsProvider = StreamProvider<UserStat>((ref) {
  return ref.watch(progressDaoProvider).watchStats();
});

final dueCountProvider = StreamProvider<int>((ref) {
  return ref.watch(progressDaoProvider).watchDueCount();
});
