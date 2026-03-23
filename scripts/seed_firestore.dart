/// Firestore seed script for Tugen App
///
/// Run with: dart run scripts/seed_firestore.dart
///
/// Requires: firebase_admin or use the Firebase Console to import this data.
/// This file defines the initial content structure. You can copy-paste the JSON
/// into Firestore Console or use the Firebase Admin SDK to seed programmatically.
///
/// For quick seeding, use the Firebase Console Import or a Node.js script with
/// firebase-admin. The data below can be exported as JSON for import.
library;

/// Category seed data
const categories = [
  {
    'id': 'greetings',
    'nameEn': 'Greetings',
    'nameSw': 'Salamu',
    'nameTug': 'Chamgei',
    'icon': '\u{1F44B}',
    'sortOrder': 1,
  },
  {
    'id': 'numbers',
    'nameEn': 'Numbers',
    'nameSw': 'Nambari',
    'nameTug': 'Sigindeek',
    'icon': '\u{1F522}',
    'sortOrder': 2,
  },
  {
    'id': 'family',
    'nameEn': 'Family',
    'nameSw': 'Familia',
    'nameTug': 'Kapchi',
    'icon': '\u{1F46A}',
    'sortOrder': 3,
  },
  {
    'id': 'food',
    'nameEn': 'Food & Market',
    'nameSw': 'Chakula na Soko',
    'nameTug': 'Amak ak Sindeet',
    'icon': '\u{1F35E}',
    'sortOrder': 4,
  },
  {
    'id': 'travel',
    'nameEn': 'Travel & Directions',
    'nameSw': 'Safari na Mwelekeo',
    'nameTug': 'Boisiet',
    'icon': '\u{1F697}',
    'sortOrder': 5,
  },
  {
    'id': 'daily',
    'nameEn': 'Daily Life',
    'nameSw': 'Maisha ya Kila Siku',
    'nameTug': 'Soboniik',
    'icon': '\u{2600}',
    'sortOrder': 6,
  },
  {
    'id': 'animals',
    'nameEn': 'Animals & Nature',
    'nameSw': 'Wanyama na Mazingira',
    'nameTug': 'Tisiik ak Emet',
    'icon': '\u{1F98A}',
    'sortOrder': 7,
  },
  {
    'id': 'proverbs',
    'nameEn': 'Proverbs & Sayings',
    'nameSw': 'Methali na Misemo',
    'nameTug': 'Ng\'aleekab Konoiik',
    'icon': '\u{1F4DC}',
    'sortOrder': 8,
  },
];

/// Phrase seed data (sample — expand with native speaker recordings)
const phrases = [
  // Greetings
  {
    'id': 'g001',
    'categoryId': 'greetings',
    'tugen': 'Chamgei',
    'english': 'Hello / Greetings',
    'swahili': 'Habari / Salamu',
    'pronunciation': 'cham-GEY',
    'difficulty': 1,
    'notes': 'Universal Kalenjin greeting, used any time of day',
  },
  {
    'id': 'g002',
    'categoryId': 'greetings',
    'tugen': 'Chamgei inyee',
    'english': 'Hello to you',
    'swahili': 'Habari yako',
    'pronunciation': 'cham-GEY in-YEE',
    'difficulty': 1,
  },
  {
    'id': 'g003',
    'categoryId': 'greetings',
    'tugen': 'Akonam ak beel?',
    'english': 'How is your home?',
    'swahili': 'Nyumba iko aje?',
    'pronunciation': 'ah-KOH-nam ak BEEL',
    'difficulty': 1,
    'notes': 'Common way to ask "how are you?" — asking about one\'s household',
  },
  {
    'id': 'g004',
    'categoryId': 'greetings',
    'tugen': 'Kagai mising',
    'english': 'Very good / Fine',
    'swahili': 'Nzuri sana',
    'pronunciation': 'kah-GUY mih-SING',
    'difficulty': 1,
  },
  {
    'id': 'g005',
    'categoryId': 'greetings',
    'tugen': 'Sait',
    'english': 'Thank you',
    'swahili': 'Asante',
    'pronunciation': 'SIGHT',
    'difficulty': 1,
  },
  {
    'id': 'g006',
    'categoryId': 'greetings',
    'tugen': 'Sait mising',
    'english': 'Thank you very much',
    'swahili': 'Asante sana',
    'pronunciation': 'SIGHT mih-SING',
    'difficulty': 1,
  },
  {
    'id': 'g007',
    'categoryId': 'greetings',
    'tugen': 'Kongoi',
    'english': 'Please',
    'swahili': 'Tafadhali',
    'pronunciation': 'kon-GOY',
    'difficulty': 1,
  },
  {
    'id': 'g008',
    'categoryId': 'greetings',
    'tugen': 'Sere',
    'english': 'Goodbye',
    'swahili': 'Kwaheri',
    'pronunciation': 'SEH-reh',
    'difficulty': 1,
  },
  {
    'id': 'g009',
    'categoryId': 'greetings',
    'tugen': 'Kabisa',
    'english': 'You are welcome',
    'swahili': 'Karibu',
    'pronunciation': 'kah-BEE-sah',
    'difficulty': 1,
  },
  {
    'id': 'g010',
    'categoryId': 'greetings',
    'tugen': 'Ee',
    'english': 'Yes',
    'swahili': 'Ndiyo',
    'pronunciation': 'EH',
    'difficulty': 1,
  },
  {
    'id': 'g011',
    'categoryId': 'greetings',
    'tugen': 'Achicha',
    'english': 'No',
    'swahili': 'Hapana',
    'pronunciation': 'ah-CHEE-cha',
    'difficulty': 1,
  },

  // Numbers
  {
    'id': 'n001',
    'categoryId': 'numbers',
    'tugen': 'Agenge',
    'english': 'One',
    'swahili': 'Moja',
    'pronunciation': 'ah-GENG-eh',
    'difficulty': 1,
  },
  {
    'id': 'n002',
    'categoryId': 'numbers',
    'tugen': 'Aeng\'',
    'english': 'Two',
    'swahili': 'Mbili',
    'pronunciation': 'AH-eng',
    'difficulty': 1,
  },
  {
    'id': 'n003',
    'categoryId': 'numbers',
    'tugen': 'Somok',
    'english': 'Three',
    'swahili': 'Tatu',
    'pronunciation': 'SOH-mok',
    'difficulty': 1,
  },
  {
    'id': 'n004',
    'categoryId': 'numbers',
    'tugen': 'Angwan',
    'english': 'Four',
    'swahili': 'Nne',
    'pronunciation': 'ANG-wan',
    'difficulty': 1,
  },
  {
    'id': 'n005',
    'categoryId': 'numbers',
    'tugen': 'Muut',
    'english': 'Five',
    'swahili': 'Tano',
    'pronunciation': 'MOOT',
    'difficulty': 1,
  },
  {
    'id': 'n006',
    'categoryId': 'numbers',
    'tugen': 'Lo',
    'english': 'Six',
    'swahili': 'Sita',
    'pronunciation': 'LOH',
    'difficulty': 1,
  },
  {
    'id': 'n007',
    'categoryId': 'numbers',
    'tugen': 'Tisap',
    'english': 'Seven',
    'swahili': 'Saba',
    'pronunciation': 'TIH-sap',
    'difficulty': 1,
  },
  {
    'id': 'n008',
    'categoryId': 'numbers',
    'tugen': 'Sisit',
    'english': 'Eight',
    'swahili': 'Nane',
    'pronunciation': 'SIH-sit',
    'difficulty': 1,
  },
  {
    'id': 'n009',
    'categoryId': 'numbers',
    'tugen': 'Sogol',
    'english': 'Nine',
    'swahili': 'Tisa',
    'pronunciation': 'SOH-gol',
    'difficulty': 1,
  },
  {
    'id': 'n010',
    'categoryId': 'numbers',
    'tugen': 'Taman',
    'english': 'Ten',
    'swahili': 'Kumi',
    'pronunciation': 'TAH-man',
    'difficulty': 1,
  },

  // Family
  {
    'id': 'f001',
    'categoryId': 'family',
    'tugen': 'Papa',
    'english': 'Father',
    'swahili': 'Baba',
    'pronunciation': 'PAH-pah',
    'difficulty': 1,
  },
  {
    'id': 'f002',
    'categoryId': 'family',
    'tugen': 'Mama',
    'english': 'Mother',
    'swahili': 'Mama',
    'pronunciation': 'MAH-mah',
    'difficulty': 1,
  },
  {
    'id': 'f003',
    'categoryId': 'family',
    'tugen': 'Lakwa',
    'english': 'Child',
    'swahili': 'Mtoto',
    'pronunciation': 'LAK-wah',
    'difficulty': 1,
  },
  {
    'id': 'f004',
    'categoryId': 'family',
    'tugen': 'Lagok',
    'english': 'Children',
    'swahili': 'Watoto',
    'pronunciation': 'lah-GOK',
    'difficulty': 1,
  },
  {
    'id': 'f005',
    'categoryId': 'family',
    'tugen': 'Kogo',
    'english': 'Grandmother',
    'swahili': 'Bibi',
    'pronunciation': 'KOH-goh',
    'difficulty': 1,
  },
  {
    'id': 'f006',
    'categoryId': 'family',
    'tugen': 'Kugo',
    'english': 'Grandfather',
    'swahili': 'Babu',
    'pronunciation': 'KOO-goh',
    'difficulty': 1,
  },

  // Food
  {
    'id': 'fd001',
    'categoryId': 'food',
    'tugen': 'Mursik',
    'english': 'Fermented milk',
    'swahili': 'Maziwa lala',
    'pronunciation': 'MOOR-sik',
    'difficulty': 1,
    'notes':
        'Traditional Kalenjin fermented milk drink, culturally important',
  },
  {
    'id': 'fd002',
    'categoryId': 'food',
    'tugen': 'Kimyet',
    'english': 'Food / Meal',
    'swahili': 'Chakula',
    'pronunciation': 'KIM-yet',
    'difficulty': 1,
  },
  {
    'id': 'fd003',
    'categoryId': 'food',
    'tugen': 'Beet',
    'english': 'Water',
    'swahili': 'Maji',
    'pronunciation': 'BEET',
    'difficulty': 1,
  },
  {
    'id': 'fd004',
    'categoryId': 'food',
    'tugen': 'Kimnyet',
    'english': 'Ugali (maize flour)',
    'swahili': 'Ugali',
    'pronunciation': 'KIM-nyet',
    'difficulty': 1,
  },
  {
    'id': 'fd005',
    'categoryId': 'food',
    'tugen': 'Chegoek',
    'english': 'Vegetables',
    'swahili': 'Mboga',
    'pronunciation': 'cheh-GOEK',
    'difficulty': 1,
  },

  // Daily
  {
    'id': 'd001',
    'categoryId': 'daily',
    'tugen': 'Tai ata?',
    'english': 'What time is it?',
    'swahili': 'Ni saa ngapi?',
    'pronunciation': 'TUY ah-TAH',
    'difficulty': 2,
  },
  {
    'id': 'd002',
    'categoryId': 'daily',
    'tugen': 'Inendet ne oo',
    'english': 'It is morning',
    'swahili': 'Ni asubuhi',
    'pronunciation': 'ih-NEN-det neh OO',
    'difficulty': 2,
  },
  {
    'id': 'd003',
    'categoryId': 'daily',
    'tugen': 'Amache',
    'english': 'I want',
    'swahili': 'Ninataka',
    'pronunciation': 'ah-MAH-cheh',
    'difficulty': 2,
  },
  {
    'id': 'd004',
    'categoryId': 'daily',
    'tugen': 'Wendi kaa?',
    'english': 'Where are you going?',
    'swahili': 'Unakwenda wapi?',
    'pronunciation': 'WEN-dee KAH',
    'difficulty': 2,
  },
];

/// Vocabulary deck seed data
const decks = [
  {
    'id': 'basic_greetings',
    'nameEn': 'Basic Greetings',
    'nameSw': 'Salamu za Msingi',
    'nameTug': 'Chamgeinik',
    'description': 'Essential greetings and polite expressions',
    'icon': '\u{1F44B}',
    'totalCards': 11,
    'isPremium': false,
  },
  {
    'id': 'numbers_1_10',
    'nameEn': 'Numbers 1-10',
    'nameSw': 'Nambari 1-10',
    'nameTug': 'Sigindeek 1-10',
    'description': 'Count from one to ten in Tugen',
    'icon': '\u{1F522}',
    'totalCards': 10,
    'isPremium': false,
  },
  {
    'id': 'family_members',
    'nameEn': 'Family Members',
    'nameSw': 'Wanafamilia',
    'nameTug': 'Kapchi',
    'description': 'Learn family relationship terms',
    'icon': '\u{1F46A}',
    'totalCards': 6,
    'isPremium': false,
  },
  {
    'id': 'food_drink',
    'nameEn': 'Food & Drink',
    'nameSw': 'Chakula na Vinywaji',
    'nameTug': 'Amak ak Beet',
    'description': 'Common food and drink vocabulary',
    'icon': '\u{1F35E}',
    'totalCards': 5,
    'isPremium': false,
  },
];

/// Vocab cards — mirror the phrases for flashcard practice
/// Each card maps to a phrase for consistent audio/content
const vocabCards = [
  // Greetings deck
  {'id': 'vc_g001', 'deckId': 'basic_greetings', 'tugen': 'Chamgei', 'english': 'Hello / Greetings', 'swahili': 'Habari / Salamu', 'difficulty': 1},
  {'id': 'vc_g002', 'deckId': 'basic_greetings', 'tugen': 'Chamgei inyee', 'english': 'Hello to you', 'swahili': 'Habari yako', 'difficulty': 1},
  {'id': 'vc_g003', 'deckId': 'basic_greetings', 'tugen': 'Kagai mising', 'english': 'Very good / Fine', 'swahili': 'Nzuri sana', 'difficulty': 1},
  {'id': 'vc_g004', 'deckId': 'basic_greetings', 'tugen': 'Sait', 'english': 'Thank you', 'swahili': 'Asante', 'difficulty': 1},
  {'id': 'vc_g005', 'deckId': 'basic_greetings', 'tugen': 'Sait mising', 'english': 'Thank you very much', 'swahili': 'Asante sana', 'difficulty': 1},
  {'id': 'vc_g006', 'deckId': 'basic_greetings', 'tugen': 'Kongoi', 'english': 'Please', 'swahili': 'Tafadhali', 'difficulty': 1},
  {'id': 'vc_g007', 'deckId': 'basic_greetings', 'tugen': 'Sere', 'english': 'Goodbye', 'swahili': 'Kwaheri', 'difficulty': 1},
  {'id': 'vc_g008', 'deckId': 'basic_greetings', 'tugen': 'Kabisa', 'english': 'You are welcome', 'swahili': 'Karibu', 'difficulty': 1},
  {'id': 'vc_g009', 'deckId': 'basic_greetings', 'tugen': 'Ee', 'english': 'Yes', 'swahili': 'Ndiyo', 'difficulty': 1},
  {'id': 'vc_g010', 'deckId': 'basic_greetings', 'tugen': 'Achicha', 'english': 'No', 'swahili': 'Hapana', 'difficulty': 1},
  {'id': 'vc_g011', 'deckId': 'basic_greetings', 'tugen': 'Akonam ak beel?', 'english': 'How is your home?', 'swahili': 'Nyumba iko aje?', 'difficulty': 1},

  // Numbers deck
  {'id': 'vc_n001', 'deckId': 'numbers_1_10', 'tugen': 'Agenge', 'english': 'One', 'swahili': 'Moja', 'difficulty': 1},
  {'id': 'vc_n002', 'deckId': 'numbers_1_10', 'tugen': 'Aeng\'', 'english': 'Two', 'swahili': 'Mbili', 'difficulty': 1},
  {'id': 'vc_n003', 'deckId': 'numbers_1_10', 'tugen': 'Somok', 'english': 'Three', 'swahili': 'Tatu', 'difficulty': 1},
  {'id': 'vc_n004', 'deckId': 'numbers_1_10', 'tugen': 'Angwan', 'english': 'Four', 'swahili': 'Nne', 'difficulty': 1},
  {'id': 'vc_n005', 'deckId': 'numbers_1_10', 'tugen': 'Muut', 'english': 'Five', 'swahili': 'Tano', 'difficulty': 1},
  {'id': 'vc_n006', 'deckId': 'numbers_1_10', 'tugen': 'Lo', 'english': 'Six', 'swahili': 'Sita', 'difficulty': 1},
  {'id': 'vc_n007', 'deckId': 'numbers_1_10', 'tugen': 'Tisap', 'english': 'Seven', 'swahili': 'Saba', 'difficulty': 1},
  {'id': 'vc_n008', 'deckId': 'numbers_1_10', 'tugen': 'Sisit', 'english': 'Eight', 'swahili': 'Nane', 'difficulty': 1},
  {'id': 'vc_n009', 'deckId': 'numbers_1_10', 'tugen': 'Sogol', 'english': 'Nine', 'swahili': 'Tisa', 'difficulty': 1},
  {'id': 'vc_n010', 'deckId': 'numbers_1_10', 'tugen': 'Taman', 'english': 'Ten', 'swahili': 'Kumi', 'difficulty': 1},

  // Family deck
  {'id': 'vc_f001', 'deckId': 'family_members', 'tugen': 'Papa', 'english': 'Father', 'swahili': 'Baba', 'difficulty': 1},
  {'id': 'vc_f002', 'deckId': 'family_members', 'tugen': 'Mama', 'english': 'Mother', 'swahili': 'Mama', 'difficulty': 1},
  {'id': 'vc_f003', 'deckId': 'family_members', 'tugen': 'Lakwa', 'english': 'Child', 'swahili': 'Mtoto', 'difficulty': 1},
  {'id': 'vc_f004', 'deckId': 'family_members', 'tugen': 'Lagok', 'english': 'Children', 'swahili': 'Watoto', 'difficulty': 1},
  {'id': 'vc_f005', 'deckId': 'family_members', 'tugen': 'Kogo', 'english': 'Grandmother', 'swahili': 'Bibi', 'difficulty': 1},
  {'id': 'vc_f006', 'deckId': 'family_members', 'tugen': 'Kugo', 'english': 'Grandfather', 'swahili': 'Babu', 'difficulty': 1},

  // Food deck
  {'id': 'vc_fd001', 'deckId': 'food_drink', 'tugen': 'Mursik', 'english': 'Fermented milk', 'swahili': 'Maziwa lala', 'difficulty': 1},
  {'id': 'vc_fd002', 'deckId': 'food_drink', 'tugen': 'Kimyet', 'english': 'Food / Meal', 'swahili': 'Chakula', 'difficulty': 1},
  {'id': 'vc_fd003', 'deckId': 'food_drink', 'tugen': 'Beet', 'english': 'Water', 'swahili': 'Maji', 'difficulty': 1},
  {'id': 'vc_fd004', 'deckId': 'food_drink', 'tugen': 'Kimnyet', 'english': 'Ugali', 'swahili': 'Ugali', 'difficulty': 1},
  {'id': 'vc_fd005', 'deckId': 'food_drink', 'tugen': 'Chegoek', 'english': 'Vegetables', 'swahili': 'Mboga', 'difficulty': 1},
];

/// Sample story
const stories = [
  {
    'id': 'story_hare_hyena',
    'titleEn': 'The Hare and the Hyena',
    'titleSw': 'Sungura na Fisi',
    'titleTug': 'Chemoset ak Kimnyigei',
    'description': 'A traditional Tugen tale about cleverness',
    'durationSeconds': 180,
    'difficulty': 'beginner',
  },
];

/// Sample story segments
const storySegments = [
  {
    'id': 'seg_hh_001',
    'storyId': 'story_hare_hyena',
    'startMs': 0,
    'endMs': 15000,
    'tugen': 'Mi betut agenge, kiboisie Chemoset ak Kimnyigei kora.',
    'english': 'One day, the Hare and the Hyena went walking together.',
    'swahili': 'Siku moja, Sungura na Fisi walitembea pamoja.',
    'sortOrder': 1,
  },
  {
    'id': 'seg_hh_002',
    'storyId': 'story_hare_hyena',
    'startMs': 15000,
    'endMs': 30000,
    'tugen': 'Kimwa Kimnyigei, "Amache kimyet, kaat amwa?"',
    'english': 'The Hyena said, "I want food, where can I find it?"',
    'swahili': 'Fisi alisema, "Ninataka chakula, nitapata wapi?"',
    'sortOrder': 2,
  },
  {
    'id': 'seg_hh_003',
    'storyId': 'story_hare_hyena',
    'startMs': 30000,
    'endMs': 45000,
    'tugen': 'Kimwa Chemoset, "Wendi ak ana, anyorun ananam."',
    'english': 'The Hare said, "Come with me, I know a place."',
    'swahili': 'Sungura alisema, "Njoo nami, najua mahali."',
    'sortOrder': 3,
  },
  {
    'id': 'seg_hh_004',
    'storyId': 'story_hare_hyena',
    'startMs': 45000,
    'endMs': 60000,
    'tugen': 'Kiwendi kobeel ne mi amak che chang.',
    'english': 'They went to a homestead that had plenty of food.',
    'swahili': 'Walikwenda nyumbani ambapo kulikuwa na chakula kingi.',
    'sortOrder': 4,
  },
];

void main() {
  print('=== Tugen App Seed Data ===');
  print('');
  print('Categories: ${categories.length}');
  print('Phrases: ${phrases.length}');
  print('Decks: ${decks.length}');
  print('Vocab Cards: ${vocabCards.length}');
  print('Stories: ${stories.length}');
  print('Story Segments: ${storySegments.length}');
  print('');
  print('To seed Firestore:');
  print('1. Go to Firebase Console > Firestore');
  print('2. Create collections: categories, phrases, decks, vocabCards, stories, storySegments');
  print('3. Import documents using the data structures above');
  print('');
  print('Or use firebase-admin Node.js SDK to seed programmatically.');
}
