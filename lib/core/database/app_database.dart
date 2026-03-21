import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ─── Content Tables ───

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameSw => text()();
  TextColumn get nameTug => text()();
  TextColumn get icon => text().withDefault(const Constant('📚'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Phrases extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId =>
      text().references(Categories, #id)();
  TextColumn get tugen => text()();
  TextColumn get english => text()();
  TextColumn get swahili => text()();
  TextColumn get pronunciation => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  IntColumn get difficulty =>
      integer().withDefault(const Constant(1))(); // 1-5
  TextColumn get notes => text().nullable()();
  BoolColumn get isDownloaded =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Decks extends Table {
  TextColumn get id => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameSw => text()();
  TextColumn get nameTug => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().withDefault(const Constant('🃏'))();
  IntColumn get totalCards => integer().withDefault(const Constant(0))();
  BoolColumn get isPremium =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class VocabCards extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text().references(Decks, #id)();
  TextColumn get tugen => text()();
  TextColumn get english => text()();
  TextColumn get swahili => text()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get difficulty =>
      integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class Stories extends Table {
  TextColumn get id => text()();
  TextColumn get titleEn => text()();
  TextColumn get titleSw => text()();
  TextColumn get titleTug => text()();
  TextColumn get description => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get durationSeconds =>
      integer().withDefault(const Constant(0))();
  TextColumn get difficulty => text().withDefault(const Constant('beginner'))();
  TextColumn get coverImageUrl => text().nullable()();
  BoolColumn get isDownloaded =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class StorySegments extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(Stories, #id)();
  IntColumn get startMs => integer()();
  IntColumn get endMs => integer()();
  TextColumn get tugen => text()();
  TextColumn get english => text()();
  TextColumn get swahili => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── User Progress Tables ───

class UserProgress extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()(); // vocab card or phrase ID
  TextColumn get cardType => text()(); // 'phrase' | 'vocab'
  RealColumn get stability => real().withDefault(const Constant(0.0))();
  RealColumn get difficulty =>
      real().withDefault(const Constant(0.3))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  IntColumn get state =>
      integer().withDefault(const Constant(0))(); // FSRS state enum
  DateTimeColumn get lastReview => dateTime().nullable()();
  DateTimeColumn get nextReview => dateTime().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get phraseId => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class QuizResults extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text().nullable()();
  TextColumn get quizType => text()(); // 'mcq', 'listening', 'spelling'
  IntColumn get totalQuestions => integer()();
  IntColumn get correctAnswers => integer()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get completedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class UserStats extends Table {
  TextColumn get id =>
      text().withDefault(const Constant('current'))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get currentStreak =>
      integer().withDefault(const Constant(0))();
  IntColumn get longestStreak =>
      integer().withDefault(const Constant(0))();
  IntColumn get wordsLearned =>
      integer().withDefault(const Constant(0))();
  IntColumn get storiesCompleted =>
      integer().withDefault(const Constant(0))();
  IntColumn get quizzesCompleted =>
      integer().withDefault(const Constant(0))();
  IntColumn get hearts =>
      integer().withDefault(const Constant(5))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();
  DateTimeColumn get heartsRegenAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get badgeId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get unlockedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Sync Queue ───

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()(); // 'create', 'update', 'delete'
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()(); // JSON
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  IntColumn get retryCount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Database Definition ───

@DriftDatabase(tables: [
  Categories,
  Phrases,
  Decks,
  VocabCards,
  Stories,
  StorySegments,
  UserProgress,
  Bookmarks,
  QuizResults,
  UserStats,
  Achievements,
  SyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tugen_db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed default user stats
        await into(userStats).insert(
          UserStatsCompanion.insert(),
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations
      },
    );
  }
}
