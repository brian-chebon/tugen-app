import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/daos/stories_dao.dart';

final storiesDaoProvider = Provider<StoriesDao>((ref) {
  return StoriesDao(ref.watch(databaseProvider));
});

final storiesProvider = StreamProvider<List<Story>>((ref) {
  return ref.watch(storiesDaoProvider).watchStories();
});

final storySegmentsProvider =
    StreamProvider.family<List<StorySegment>, String>((ref, storyId) {
  return ref.watch(storiesDaoProvider).watchSegments(storyId);
});

final selectedDifficultyProvider = StateProvider<String?>((ref) => null);
