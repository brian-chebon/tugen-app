/// App-wide constants
class AppConstants {
  AppConstants._();

  // Gamification
  static const int maxHearts = 5;
  static const int heartRegenMinutes = 30;
  static const int xpPerCorrectAnswer = 10;
  static const int xpBonusPerfectQuiz = 20;
  static const int xpBonusStreak = 5;
  static const int defaultDailyGoalXp = 20;
  static const int newCardsPerSession = 5;
  static const int reviewCardsPerSession = 15;

  // Audio
  static const double defaultPlaybackSpeed = 1.0;
  static const double slowPlaybackSpeed = 0.7;
  static const List<double> playbackSpeeds = [0.5, 0.7, 1.0, 1.25, 1.5];

  // FSRS defaults
  static const double desiredRetention = 0.9;

  // Sync
  static const int maxSyncRetries = 3;
  static const int syncBatchSize = 50;

  // Firebase collections
  static const String colCategories = 'categories';
  static const String colPhrases = 'phrases';
  static const String colDecks = 'decks';
  static const String colVocabCards = 'vocabCards';
  static const String colStories = 'stories';
  static const String colStorySegments = 'storySegments';
  static const String colUsers = 'users';
  static const String colProgress = 'progress';
  static const String colQuizResults = 'quizResults';
  static const String colStats = 'stats';

  // Achievement badge IDs
  static const String badge7DayStreak = 'streak_7';
  static const String badge30DayStreak = 'streak_30';
  static const String badge100DayStreak = 'streak_100';
  static const String badge50Words = 'words_50';
  static const String badge200Words = 'words_200';
  static const String badge500Words = 'words_500';
  static const String badgeFirstStory = 'story_first';
  static const String badge10Stories = 'story_10';
  static const String badgePerfectQuiz = 'quiz_perfect';
}
