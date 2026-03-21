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
      'search': 'Search',
      'categories': 'Categories',
      'greetings': 'Greetings',
      'numbers': 'Numbers',
      'family': 'Family',
      'food': 'Food & Market',
      'travel': 'Travel',
      'dailyGoal': 'Daily Goal',
      'streak': 'Day Streak',
      'wordsLearned': 'Words Learned',
      'xp': 'XP',
      'quiz': 'Quiz',
      'flashcards': 'Flashcards',
      'startLesson': 'Start Lesson',
      'correct': 'Correct!',
      'tryAgain': 'Try Again',
      'wellDone': 'Well Done!',
      'keepGoing': 'Keep Going!',
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
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'listenAndRepeat': 'Listen and Repeat',
      'translateThis': 'Translate This',
      'whatDoYouHear': 'What do you hear?',
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'continueAsGuest': 'Continue as Guest',
      'language': 'Language',
      'clearCache': 'Clear Audio Cache',
      'cacheSize': 'Cache Size',
      'about': 'About',
      'privacyPolicy': 'Privacy Policy',
      'logout': 'Log Out',
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
      'search': 'Tafuta',
      'categories': 'Makundi',
      'greetings': 'Salamu',
      'numbers': 'Nambari',
      'family': 'Familia',
      'food': 'Chakula na Soko',
      'travel': 'Safari',
      'dailyGoal': 'Lengo la Kila Siku',
      'streak': 'Siku Mfululizo',
      'wordsLearned': 'Maneno Uliyojifunza',
      'xp': 'XP',
      'quiz': 'Jaribio',
      'flashcards': 'Kadi za Kujifunza',
      'startLesson': 'Anza Somo',
      'correct': 'Sahihi!',
      'tryAgain': 'Jaribu Tena',
      'wellDone': 'Umefanya Vizuri!',
      'keepGoing': 'Endelea!',
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
      'beginner': 'Mwanzo',
      'intermediate': 'Kati',
      'advanced': 'Juu',
      'signIn': 'Ingia',
      'signUp': 'Jisajili',
      'continueAsGuest': 'Endelea kama Mgeni',
      'language': 'Lugha',
      'logout': 'Toka',
    },
    'tug': {
      'appName': 'Tugen',
      'phrasebook': 'Ng\'aleekab',
      'play': 'Iit',
      'next': 'Ak',
      'back': 'Nee',
      'replay': 'Iit kole',
      'greetings': 'Chamgei',
      'numbers': 'Sigindeek',
      'family': 'Kapchi',
      // Tugen translations to be expanded with native speakers
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
  String get search => translate('search');
  String get categories => translate('categories');
  String get quiz => translate('quiz');
  String get flashcards => translate('flashcards');
  String get correct => translate('correct');
  String get tryAgain => translate('tryAgain');
  String get wellDone => translate('wellDone');
  String get easy => translate('easy');
  String get good => translate('good');
  String get hard => translate('hard');
  String get again => translate('again');
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
