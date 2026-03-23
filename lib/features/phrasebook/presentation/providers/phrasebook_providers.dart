import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/daos/phrases_dao.dart';

final phrasesDaoProvider = Provider<PhrasesDao>((ref) {
  return PhrasesDao(ref.watch(databaseProvider));
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(phrasesDaoProvider).watchCategories();
});

final phrasesByCategoryProvider =
    StreamProvider.family<List<Phrase>, String>((ref, categoryId) {
  return ref.watch(phrasesDaoProvider).watchPhrasesByCategory(categoryId);
});

final phraseSearchProvider =
    StreamProvider.family<List<Phrase>, String>((ref, query) {
  if (query.isEmpty) return Stream.value([]);
  return ref.watch(phrasesDaoProvider).searchPhrases(query);
});

final bookmarkedPhrasesProvider = StreamProvider<List<Phrase>>((ref) {
  return ref.watch(phrasesDaoProvider).watchBookmarkedPhrases();
});

final isBookmarkedProvider =
    StreamProvider.family<bool, String>((ref, phraseId) {
  return ref.watch(phrasesDaoProvider).watchIsBookmarked(phraseId);
});

/// Search query state
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}
