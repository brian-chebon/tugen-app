import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Supported locales for the app
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('sw'),
    Locale.fromSubtags(languageCode: 'tug'), // Tugen ISO 639-3
  ];

  // ─── Translation maps ───

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Tugen',
      'phrasebook': 'Phrases',
      'vocabGame': 'Learn',
      'stories': 'Stories',
      'profile': 'Profile',
      'settings': 'Settings',
      'play': 'Play',
      'pause': 'Pause',
      'next': 'Next',
      'back': 'Back',
      'replay': 'Replay',
      'bookmark': 'Bookmark',
      'bookmarkedPhrases': 'Bookmarked Phrases',
      'noBookmarks': 'No bookmarks yet',
      'search': 'Search',
      'searchHint': 'Search phrases in Tugen, English, or Swahili...',
      'categories': 'Categories',
      'greetings': 'Greetings',
      'numbers': 'Numbers',
      'family': 'Family',
      'food': 'Food & Market',
      'travel': 'Travel',
      'dailyGoal': 'Daily Goal',
      'streak': 'Day Streak',
      'longestStreak': 'Longest Streak',
      'wordsLearned': 'Words Learned',
      'xp': 'XP',
      'totalXp': 'Total XP',
      'quiz': 'Quiz',
      'quizzes': 'Quizzes',
      'flashcards': 'Flashcards',
      'startLesson': 'Start Lesson',
      'correct': 'Correct!',
      'tryAgain': 'Try Again',
      'wellDone': 'Well Done!',
      'keepGoing': 'Keep Going!',
      'perfect': 'Perfect!',
      'greatJob': 'Great job!',
      'keepPracticing': 'Keep practicing!',
      'hearts': 'Hearts',
      'easy': 'Easy',
      'good': 'Good',
      'hard': 'Hard',
      'again': 'Again',
      'downloadForOffline': 'Download for Offline',
      'downloading': 'Downloading...',
      'downloaded': 'Downloaded',
      'noInternet': 'No Internet Connection',
      'offlineMode': 'Offline Mode',
      'offlineBanner': 'You are offline — cached content available',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'listenAndRepeat': 'Listen and Repeat',
      'translateThis': 'Translate This',
      'whatDoYouHear': 'What do you hear?',
      'whatDoesThisMean': 'What does this mean?',
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'createAccount': 'Create Account',
      'continueAsGuest': 'Continue as Guest',
      'noAccount': "Don't have an account? Sign Up",
      'hasAccount': 'Already have an account? Sign In',
      'forgotPassword': 'Forgot Password?',
      'resetPasswordSent': 'Password reset email sent',
      'email': 'Email',
      'password': 'Password',
      'validEmail': 'Enter valid email',
      'minPassword': 'Min 6 characters',
      'learnTugen': 'Learn the Tugen Language',
      'language': 'Language',
      'appLanguage': 'App Language',
      'selectLanguage': 'Select Language',
      'clearCache': 'Clear Audio Cache',
      'clearCacheDesc': 'Remove downloaded audio files',
      'clearCacheConfirm': 'Clear Cache?',
      'clearCacheMsg':
          'This will remove all downloaded audio. You can re-download them later.',
      'cancel': 'Cancel',
      'clear': 'Clear',
      'cacheCleared': 'Cache cleared',
      'cacheSize': 'Cache Size',
      'audioCache': 'Audio Cache',
      'storage': 'Storage',
      'account': 'Account',
      'about': 'About',
      'aboutDesc': 'Tugen Language Learning App',
      'privacyPolicy': 'Privacy Policy',
      'privacyPolicyDesc': 'How we handle your data',
      'logout': 'Log Out',
      'madeWith': 'Made with love for Tugen speakers',
      'vocabularyDecks': 'Vocabulary Decks',
      'cardsLabel': 'cards',
      'cardsDueForReview': 'cards due for review',
      'review': 'Review',
      'allCaughtUp': 'All caught up!',
      'noCardsDue': 'No cards due for review.',
      'sessionComplete': 'Session Complete!',
      'reviewedCards': 'Reviewed {count} cards',
      'done': 'Done',
      'tapToReveal': 'Tap to reveal',
      'results': 'Results',
      'correctCount': '{correct} / {total} correct',
      'needMinCards': 'Need at least 4 cards in the deck for a quiz.',
      'noPhrases': 'No phrases yet',
      'noStories': 'No stories available yet.',
      'all': 'All',
      'phrases': 'Phrases',
      'english': 'English',
      'swahili': 'Swahili',
      'notes': 'Notes',
      'guestLearner': 'Guest Learner',
      'saveProgress':
          'Create an account to save your progress across devices!',
      'noHeartsTitle': 'No Hearts Left!',
      'noHeartsMsg':
          'Hearts regenerate over time. Come back in a few minutes.',
      'ok': 'OK',
      'achievements': 'Achievements',
      'version': 'Version',
      'calculating': 'Calculating...',
      'notSet': 'Not set',
      'toggleTranslation': 'Toggle translation',
    },
    'sw': {
      'appName': 'Tugen',
      'phrasebook': 'Misemo',
      'vocabGame': 'Jifunze',
      'stories': 'Hadithi',
      'profile': 'Wasifu',
      'settings': 'Mipangilio',
      'play': 'Cheza',
      'pause': 'Simama',
      'next': 'Ifuatayo',
      'back': 'Rudi',
      'replay': 'Rudia',
      'bookmark': 'Alamisho',
      'bookmarkedPhrases': 'Misemo Uliyoalamisho',
      'noBookmarks': 'Hakuna alamisho bado',
      'search': 'Tafuta',
      'searchHint': 'Tafuta misemo kwa Tugen, Kiingereza, au Kiswahili...',
      'categories': 'Makundi',
      'greetings': 'Salamu',
      'numbers': 'Nambari',
      'family': 'Familia',
      'food': 'Chakula na Soko',
      'travel': 'Safari',
      'dailyGoal': 'Lengo la Kila Siku',
      'streak': 'Siku Mfululizo',
      'longestStreak': 'Mfululizo Mrefu',
      'wordsLearned': 'Maneno Uliyojifunza',
      'xp': 'XP',
      'totalXp': 'Jumla XP',
      'quiz': 'Jaribio',
      'quizzes': 'Majaribio',
      'flashcards': 'Kadi za Kujifunza',
      'startLesson': 'Anza Somo',
      'correct': 'Sahihi!',
      'tryAgain': 'Jaribu Tena',
      'wellDone': 'Umefanya Vizuri!',
      'keepGoing': 'Endelea!',
      'perfect': 'Kamili!',
      'greatJob': 'Kazi nzuri!',
      'keepPracticing': 'Endelea kufanya mazoezi!',
      'hearts': 'Mioyo',
      'easy': 'Rahisi',
      'good': 'Nzuri',
      'hard': 'Ngumu',
      'again': 'Tena',
      'downloadForOffline': 'Pakua kwa matumizi nje ya mtandao',
      'downloading': 'Inapakua...',
      'downloaded': 'Imepakua',
      'noInternet': 'Hakuna Mtandao',
      'offlineMode': 'Hali ya Nje ya Mtandao',
      'offlineBanner': 'Uko nje ya mtandao — maudhui yaliyohifadhiwa yanapatikana',
      'beginner': 'Mwanzo',
      'intermediate': 'Kati',
      'advanced': 'Juu',
      'listenAndRepeat': 'Sikiliza na Rudia',
      'translateThis': 'Tafsiri Hii',
      'whatDoYouHear': 'Unasikia nini?',
      'whatDoesThisMean': 'Hii inamaanisha nini?',
      'signIn': 'Ingia',
      'signUp': 'Jisajili',
      'createAccount': 'Fungua Akaunti',
      'continueAsGuest': 'Endelea kama Mgeni',
      'noAccount': 'Huna akaunti? Jisajili',
      'hasAccount': 'Una akaunti tayari? Ingia',
      'forgotPassword': 'Umesahau Nenosiri?',
      'resetPasswordSent': 'Barua pepe ya kubadili nenosiri imetumwa',
      'email': 'Barua pepe',
      'password': 'Nenosiri',
      'validEmail': 'Weka barua pepe sahihi',
      'minPassword': 'Herufi 6 au zaidi',
      'learnTugen': 'Jifunze Lugha ya Tugen',
      'language': 'Lugha',
      'appLanguage': 'Lugha ya Programu',
      'selectLanguage': 'Chagua Lugha',
      'clearCache': 'Futa Kumbukumbu za Sauti',
      'clearCacheDesc': 'Ondoa faili za sauti zilizopakuwa',
      'clearCacheConfirm': 'Futa Kumbukumbu?',
      'clearCacheMsg':
          'Hii itaondoa sauti zote zilizopakuwa. Unaweza kuzipakua tena baadaye.',
      'cancel': 'Ghairi',
      'clear': 'Futa',
      'cacheCleared': 'Kumbukumbu zimefutwa',
      'cacheSize': 'Ukubwa wa Kumbukumbu',
      'audioCache': 'Kumbukumbu za Sauti',
      'storage': 'Hifadhi',
      'account': 'Akaunti',
      'about': 'Kuhusu',
      'aboutDesc': 'Programu ya Kujifunza Lugha ya Tugen',
      'privacyPolicy': 'Sera ya Faragha',
      'privacyPolicyDesc': 'Jinsi tunavyoshughulikia data yako',
      'logout': 'Toka',
      'madeWith': 'Imetengenezwa kwa upendo kwa wazungumzaji wa Tugen',
      'vocabularyDecks': 'Makundi ya Msamiati',
      'cardsLabel': 'kadi',
      'cardsDueForReview': 'kadi zinahitaji kurejeshwa',
      'review': 'Rejea',
      'allCaughtUp': 'Umekamilisha yote!',
      'noCardsDue': 'Hakuna kadi za kurejea.',
      'sessionComplete': 'Kipindi Kimekamilika!',
      'reviewedCards': 'Umerejea kadi {count}',
      'done': 'Maliza',
      'tapToReveal': 'Gusa kuona',
      'results': 'Matokeo',
      'correctCount': '{correct} / {total} sahihi',
      'needMinCards': 'Unahitaji angalau kadi 4 kwa jaribio.',
      'noPhrases': 'Hakuna misemo bado',
      'noStories': 'Hakuna hadithi bado.',
      'all': 'Zote',
      'phrases': 'Misemo',
      'english': 'Kiingereza',
      'swahili': 'Kiswahili',
      'notes': 'Maelezo',
      'guestLearner': 'Mgeni Anayejifunza',
      'saveProgress':
          'Fungua akaunti ili kuhifadhi maendeleo yako kwenye vifaa vyote!',
      'noHeartsTitle': 'Mioyo Imeisha!',
      'noHeartsMsg':
          'Mioyo inazalishwa tena baada ya muda. Rudi baada ya dakika chache.',
      'ok': 'Sawa',
      'achievements': 'Mafanikio',
      'version': 'Toleo',
      'calculating': 'Inahesabu...',
      'notSet': 'Haijawekwa',
      'toggleTranslation': 'Onyesha/ficha tafsiri',
    },
    'tug': {
      'appName': 'Tugen',
      'phrasebook': "Ng'aleekab",
      'vocabGame': 'Amesinei',
      'stories': 'Tisirek',
      'profile': 'Kainenyun',
      'settings': 'Icheeget',
      'play': 'Iit',
      'pause': 'Birra',
      'next': 'Ak',
      'back': 'Nee',
      'replay': 'Iit kole',
      'bookmark': 'Tebi',
      'bookmarkedPhrases': "Ng'aleekab che kitebi",
      'noBookmarks': 'Ma mi che kitebi',
      'search': 'Choor',
      'searchHint': "Choor ng'aleekab...",
      'categories': 'Betusiek',
      'greetings': 'Chamgei',
      'numbers': 'Sigindeek',
      'family': 'Kapchi',
      'food': 'Amak ak Sindeet',
      'travel': 'Boisiet',
      'dailyGoal': 'Koimet ne kasarta',
      'streak': 'Betusiek che kiboisie',
      'longestStreak': 'Ibinda ne missing',
      'wordsLearned': "Ng'aleekab che kiames",
      'xp': 'XP',
      'totalXp': 'XP tugul',
      'quiz': 'Tereneet',
      'quizzes': 'Tereneek',
      'flashcards': 'Kadinik',
      'startLesson': 'Teech somo',
      'correct': 'Katoog!',
      'tryAgain': 'Teech kole',
      'wellDone': 'Kagai mising!',
      'keepGoing': 'Wendi!',
      'perfect': 'Kagai tugul!',
      'greatJob': 'Kagai mising!',
      'keepPracticing': 'Wendi ak amesineet!',
      'hearts': 'Mugulelnik',
      'easy': 'Nyolu',
      'good': 'Kagai',
      'hard': 'Memuuch',
      'again': 'Kole',
      'downloadForOffline': 'Imuut agoi agas kou ne metinye internet',
      'downloading': 'Kimuutie...',
      'downloaded': 'Kimuut',
      'noInternet': 'Ma mi internet',
      'offlineMode': 'Kou ne ma mi internet',
      'offlineBanner': 'Ma mi internet — mi amwa che kihifadhi',
      'beginner': 'Ne teech',
      'intermediate': 'Ne katam tengel',
      'advanced': 'Ne ngunon',
      'signIn': 'Inweet',
      'signUp': 'Sigil',
      'createAccount': 'Yai akaunti',
      'continueAsGuest': 'Wendi kou oriin',
      'noAccount': 'Ma mi akaunti? Sigil',
      'hasAccount': 'Mi akaunti? Inweet',
      'forgotPassword': 'Kimwaei nenosiri?',
      'email': 'Barua pepe',
      'password': 'Nenosiri',
      'learnTugen': 'Amesinei Kutit ne Tugen',
      'language': 'Kutit',
      'appLanguage': 'Kutit ne Programu',
      'selectLanguage': 'Til Kutit',
      'clearCache': 'Tep kumbukumbu',
      'cancel': 'Birra',
      'ok': 'Sawa',
      'done': 'Kigol',
      'all': 'Tugul',
      'phrases': "Ng'aleekab",
      'english': 'Kizungu',
      'swahili': 'Kiswahili',
      'guestLearner': 'Oriin ne amesinei',
      'about': 'Agobo',
      'logout': 'Konyo',
      'madeWith': "Kiyai ak chameet agoi chebo ng'aleet ab Tugen",
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Convenience getters
  String get appName => translate('appName');
  String get phrasebook => translate('phrasebook');
  String get vocabGame => translate('vocabGame');
  String get stories => translate('stories');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get play => translate('play');
  String get pause => translate('pause');
  String get next => translate('next');
  String get back => translate('back');
  String get replay => translate('replay');
  String get bookmark => translate('bookmark');
  String get bookmarkedPhrases => translate('bookmarkedPhrases');
  String get noBookmarks => translate('noBookmarks');
  String get search => translate('search');
  String get searchHint => translate('searchHint');
  String get categories => translate('categories');
  String get quiz => translate('quiz');
  String get quizzes => translate('quizzes');
  String get flashcards => translate('flashcards');
  String get correct => translate('correct');
  String get tryAgain => translate('tryAgain');
  String get wellDone => translate('wellDone');
  String get keepGoing => translate('keepGoing');
  String get perfect => translate('perfect');
  String get greatJob => translate('greatJob');
  String get keepPracticing => translate('keepPracticing');
  String get easy => translate('easy');
  String get good => translate('good');
  String get hard => translate('hard');
  String get again => translate('again');
  String get hearts => translate('hearts');
  String get streak => translate('streak');
  String get longestStreak => translate('longestStreak');
  String get wordsLearned => translate('wordsLearned');
  String get xp => translate('xp');
  String get totalXp => translate('totalXp');
  String get beginner => translate('beginner');
  String get intermediate => translate('intermediate');
  String get advanced => translate('advanced');
  String get signIn => translate('signIn');
  String get signUp => translate('signUp');
  String get createAccount => translate('createAccount');
  String get continueAsGuest => translate('continueAsGuest');
  String get noAccount => translate('noAccount');
  String get hasAccount => translate('hasAccount');
  String get forgotPassword => translate('forgotPassword');
  String get resetPasswordSent => translate('resetPasswordSent');
  String get email => translate('email');
  String get password => translate('password');
  String get validEmail => translate('validEmail');
  String get minPassword => translate('minPassword');
  String get learnTugen => translate('learnTugen');
  String get language => translate('language');
  String get appLanguage => translate('appLanguage');
  String get selectLanguage => translate('selectLanguage');
  String get clearCache => translate('clearCache');
  String get clearCacheDesc => translate('clearCacheDesc');
  String get clearCacheConfirm => translate('clearCacheConfirm');
  String get clearCacheMsg => translate('clearCacheMsg');
  String get cancel => translate('cancel');
  String get clear => translate('clear');
  String get cacheCleared => translate('cacheCleared');
  String get cacheSize => translate('cacheSize');
  String get audioCache => translate('audioCache');
  String get storage => translate('storage');
  String get account => translate('account');
  String get about => translate('about');
  String get aboutDesc => translate('aboutDesc');
  String get privacyPolicy => translate('privacyPolicy');
  String get privacyPolicyDesc => translate('privacyPolicyDesc');
  String get logout => translate('logout');
  String get madeWith => translate('madeWith');
  String get vocabularyDecks => translate('vocabularyDecks');
  String get cardsLabel => translate('cardsLabel');
  String get cardsDueForReview => translate('cardsDueForReview');
  String get review => translate('review');
  String get allCaughtUp => translate('allCaughtUp');
  String get noCardsDue => translate('noCardsDue');
  String get sessionComplete => translate('sessionComplete');
  String get done => translate('done');
  String get tapToReveal => translate('tapToReveal');
  String get results => translate('results');
  String get needMinCards => translate('needMinCards');
  String get noPhrases => translate('noPhrases');
  String get noStories => translate('noStories');
  String get all => translate('all');
  String get phrases => translate('phrases');
  String get english => translate('english');
  String get swahili => translate('swahili');
  String get notes => translate('notes');
  String get guestLearner => translate('guestLearner');
  String get saveProgress => translate('saveProgress');
  String get noHeartsTitle => translate('noHeartsTitle');
  String get noHeartsMsg => translate('noHeartsMsg');
  String get ok => translate('ok');
  String get downloadForOffline => translate('downloadForOffline');
  String get downloading => translate('downloading');
  String get downloaded => translate('downloaded');
  String get offlineBanner => translate('offlineBanner');
  String get whatDoesThisMean => translate('whatDoesThisMean');
  String get toggleTranslation => translate('toggleTranslation');
  String get calculating => translate('calculating');
  String get version => translate('version');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sw', 'tug'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
