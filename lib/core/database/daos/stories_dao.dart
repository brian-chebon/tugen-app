import 'package:drift/drift.dart';

import '../app_database.dart';

part 'stories_dao.g.dart';

@DriftAccessor(tables: [Stories, StorySegments])
class StoriesDao extends DatabaseAccessor<AppDatabase>
    with _$StoriesDaoMixin {
  StoriesDao(super.db);

  /// Watch all stories
  Stream<List<Story>> watchStories() {
    return (select(stories)
          ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
        .watch();
  }

  /// Watch stories by difficulty
  Stream<List<Story>> watchStoriesByDifficulty(String difficulty) {
    return (select(stories)
          ..where((s) => s.difficulty.equals(difficulty)))
        .watch();
  }

  /// Get story with segments
  Future<Story?> getStory(String id) {
    return (select(stories)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch segments for a story (ordered)
  Stream<List<StorySegment>> watchSegments(String storyId) {
    return (select(storySegments)
          ..where((s) => s.storyId.equals(storyId))
          ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .watch();
  }

  /// Mark story audio as downloaded
  Future<void> markDownloaded(String storyId, String localPath) {
    return (update(stories)..where((s) => s.id.equals(storyId))).write(
      StoriesCompanion(
        isDownloaded: const Value(true),
        audioPath: Value(localPath),
      ),
    );
  }

  /// Batch insert stories
  Future<void> insertStories(List<StoriesCompanion> items) async {
    await batch((b) => b.insertAllOnConflictUpdate(stories, items));
  }

  /// Batch insert segments
  Future<void> insertSegments(List<StorySegmentsCompanion> items) async {
    await batch((b) => b.insertAllOnConflictUpdate(storySegments, items));
  }
}
