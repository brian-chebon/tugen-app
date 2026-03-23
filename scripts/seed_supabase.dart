/// Supabase seed script for Tugen App
///
/// Run with: dart run scripts/seed_supabase.dart
///
/// Requires: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables.
/// Uses the Supabase service role key (not anon key) to bypass RLS for seeding.
///
/// Alternative: Copy the SQL INSERT statements from supabase/schema.sql
/// and run them in the Supabase SQL Editor.
library;

/// Category seed data (Supabase snake_case columns)
const categories = [
  {
    'id': 'greetings',
    'name_en': 'Greetings',
    'name_sw': 'Salamu',
    'name_tug': 'Chamgei',
    'icon': '\u{1F44B}',
    'sort_order': 1,
  },
  {
    'id': 'numbers',
    'name_en': 'Numbers',
    'name_sw': 'Nambari',
    'name_tug': 'Sigindeek',
    'icon': '\u{1F522}',
    'sort_order': 2,
  },
  {
    'id': 'family',
    'name_en': 'Family',
    'name_sw': 'Familia',
    'name_tug': 'Kapchi',
    'icon': '\u{1F46A}',
    'sort_order': 3,
  },
  {
    'id': 'food',
    'name_en': 'Food & Market',
    'name_sw': 'Chakula na Soko',
    'name_tug': 'Amak ak Sindeet',
    'icon': '\u{1F35E}',
    'sort_order': 4,
  },
  {
    'id': 'travel',
    'name_en': 'Travel & Directions',
    'name_sw': 'Safari na Mwelekeo',
    'name_tug': 'Boisiet',
    'icon': '\u{1F697}',
    'sort_order': 5,
  },
  {
    'id': 'daily',
    'name_en': 'Daily Life',
    'name_sw': 'Maisha ya Kila Siku',
    'name_tug': 'Soboniik',
    'icon': '\u{2600}',
    'sort_order': 6,
  },
  {
    'id': 'animals',
    'name_en': 'Animals & Nature',
    'name_sw': 'Wanyama na Mazingira',
    'name_tug': 'Tisiik ak Emet',
    'icon': '\u{1F98A}',
    'sort_order': 7,
  },
  {
    'id': 'proverbs',
    'name_en': 'Proverbs & Sayings',
    'name_sw': 'Methali na Misemo',
    'name_tug': 'Ng\'aleekab Konoiik',
    'icon': '\u{1F4DC}',
    'sort_order': 8,
  },
];

/// Phrase seed data (sample — expand with native speaker recordings)
const phrases = [
  // Greetings
  {'id': 'g001', 'category_id': 'greetings', 'tugen': 'Chamgei', 'english': 'Hello / Greetings', 'swahili': 'Habari / Salamu', 'pronunciation': 'cham-GEY', 'difficulty': 1, 'notes': 'Universal Kalenjin greeting, used any time of day'},
  {'id': 'g002', 'category_id': 'greetings', 'tugen': 'Chamgei inyee', 'english': 'Hello to you', 'swahili': 'Habari yako', 'pronunciation': 'cham-GEY in-YEE', 'difficulty': 1},
  {'id': 'g003', 'category_id': 'greetings', 'tugen': 'Akonam ak beel?', 'english': 'How is your home?', 'swahili': 'Nyumba iko aje?', 'pronunciation': 'ah-KOH-nam ak BEEL', 'difficulty': 1, 'notes': 'Common way to ask "how are you?" — asking about one\'s household'},
  {'id': 'g004', 'category_id': 'greetings', 'tugen': 'Kagai mising', 'english': 'Very good / Fine', 'swahili': 'Nzuri sana', 'pronunciation': 'kah-GUY mih-SING', 'difficulty': 1},
  {'id': 'g005', 'category_id': 'greetings', 'tugen': 'Sait', 'english': 'Thank you', 'swahili': 'Asante', 'pronunciation': 'SIGHT', 'difficulty': 1},
  {'id': 'g006', 'category_id': 'greetings', 'tugen': 'Sait mising', 'english': 'Thank you very much', 'swahili': 'Asante sana', 'pronunciation': 'SIGHT mih-SING', 'difficulty': 1},
  {'id': 'g007', 'category_id': 'greetings', 'tugen': 'Kongoi', 'english': 'Please', 'swahili': 'Tafadhali', 'pronunciation': 'kon-GOY', 'difficulty': 1},
  {'id': 'g008', 'category_id': 'greetings', 'tugen': 'Sere', 'english': 'Goodbye', 'swahili': 'Kwaheri', 'pronunciation': 'SEH-reh', 'difficulty': 1},
  {'id': 'g009', 'category_id': 'greetings', 'tugen': 'Kabisa', 'english': 'You are welcome', 'swahili': 'Karibu', 'pronunciation': 'kah-BEE-sah', 'difficulty': 1},
  {'id': 'g010', 'category_id': 'greetings', 'tugen': 'Ee', 'english': 'Yes', 'swahili': 'Ndiyo', 'pronunciation': 'EH', 'difficulty': 1},
  {'id': 'g011', 'category_id': 'greetings', 'tugen': 'Achicha', 'english': 'No', 'swahili': 'Hapana', 'pronunciation': 'ah-CHEE-cha', 'difficulty': 1},

  // Numbers
  {'id': 'n001', 'category_id': 'numbers', 'tugen': 'Agenge', 'english': 'One', 'swahili': 'Moja', 'pronunciation': 'ah-GENG-eh', 'difficulty': 1},
  {'id': 'n002', 'category_id': 'numbers', 'tugen': 'Aeng\'', 'english': 'Two', 'swahili': 'Mbili', 'pronunciation': 'AH-eng', 'difficulty': 1},
  {'id': 'n003', 'category_id': 'numbers', 'tugen': 'Somok', 'english': 'Three', 'swahili': 'Tatu', 'pronunciation': 'SOH-mok', 'difficulty': 1},
  {'id': 'n004', 'category_id': 'numbers', 'tugen': 'Angwan', 'english': 'Four', 'swahili': 'Nne', 'pronunciation': 'ANG-wan', 'difficulty': 1},
  {'id': 'n005', 'category_id': 'numbers', 'tugen': 'Muut', 'english': 'Five', 'swahili': 'Tano', 'pronunciation': 'MOOT', 'difficulty': 1},
  {'id': 'n006', 'category_id': 'numbers', 'tugen': 'Lo', 'english': 'Six', 'swahili': 'Sita', 'pronunciation': 'LOH', 'difficulty': 1},
  {'id': 'n007', 'category_id': 'numbers', 'tugen': 'Tisap', 'english': 'Seven', 'swahili': 'Saba', 'pronunciation': 'TIH-sap', 'difficulty': 1},
  {'id': 'n008', 'category_id': 'numbers', 'tugen': 'Sisit', 'english': 'Eight', 'swahili': 'Nane', 'pronunciation': 'SIH-sit', 'difficulty': 1},
  {'id': 'n009', 'category_id': 'numbers', 'tugen': 'Sogol', 'english': 'Nine', 'swahili': 'Tisa', 'pronunciation': 'SOH-gol', 'difficulty': 1},
  {'id': 'n010', 'category_id': 'numbers', 'tugen': 'Taman', 'english': 'Ten', 'swahili': 'Kumi', 'pronunciation': 'TAH-man', 'difficulty': 1},

  // Family
  {'id': 'f001', 'category_id': 'family', 'tugen': 'Papa', 'english': 'Father', 'swahili': 'Baba', 'pronunciation': 'PAH-pah', 'difficulty': 1},
  {'id': 'f002', 'category_id': 'family', 'tugen': 'Mama', 'english': 'Mother', 'swahili': 'Mama', 'pronunciation': 'MAH-mah', 'difficulty': 1},
  {'id': 'f003', 'category_id': 'family', 'tugen': 'Lakwa', 'english': 'Child', 'swahili': 'Mtoto', 'pronunciation': 'LAK-wah', 'difficulty': 1},
  {'id': 'f004', 'category_id': 'family', 'tugen': 'Lagok', 'english': 'Children', 'swahili': 'Watoto', 'pronunciation': 'lah-GOK', 'difficulty': 1},
  {'id': 'f005', 'category_id': 'family', 'tugen': 'Kogo', 'english': 'Grandmother', 'swahili': 'Bibi', 'pronunciation': 'KOH-goh', 'difficulty': 1},
  {'id': 'f006', 'category_id': 'family', 'tugen': 'Kugo', 'english': 'Grandfather', 'swahili': 'Babu', 'pronunciation': 'KOO-goh', 'difficulty': 1},

  // Food
  {'id': 'fd001', 'category_id': 'food', 'tugen': 'Mursik', 'english': 'Fermented milk', 'swahili': 'Maziwa lala', 'pronunciation': 'MOOR-sik', 'difficulty': 1, 'notes': 'Traditional Kalenjin fermented milk drink, culturally important'},
  {'id': 'fd002', 'category_id': 'food', 'tugen': 'Kimyet', 'english': 'Food / Meal', 'swahili': 'Chakula', 'pronunciation': 'KIM-yet', 'difficulty': 1},
  {'id': 'fd003', 'category_id': 'food', 'tugen': 'Beet', 'english': 'Water', 'swahili': 'Maji', 'pronunciation': 'BEET', 'difficulty': 1},
  {'id': 'fd004', 'category_id': 'food', 'tugen': 'Kimnyet', 'english': 'Ugali (maize flour)', 'swahili': 'Ugali', 'pronunciation': 'KIM-nyet', 'difficulty': 1},
  {'id': 'fd005', 'category_id': 'food', 'tugen': 'Chegoek', 'english': 'Vegetables', 'swahili': 'Mboga', 'pronunciation': 'cheh-GOEK', 'difficulty': 1},

  // Daily
  {'id': 'd001', 'category_id': 'daily', 'tugen': 'Tai ata?', 'english': 'What time is it?', 'swahili': 'Ni saa ngapi?', 'pronunciation': 'TUY ah-TAH', 'difficulty': 2},
  {'id': 'd002', 'category_id': 'daily', 'tugen': 'Inendet ne oo', 'english': 'It is morning', 'swahili': 'Ni asubuhi', 'pronunciation': 'ih-NEN-det neh OO', 'difficulty': 2},
  {'id': 'd003', 'category_id': 'daily', 'tugen': 'Amache', 'english': 'I want', 'swahili': 'Ninataka', 'pronunciation': 'ah-MAH-cheh', 'difficulty': 2},
  {'id': 'd004', 'category_id': 'daily', 'tugen': 'Wendi kaa?', 'english': 'Where are you going?', 'swahili': 'Unakwenda wapi?', 'pronunciation': 'WEN-dee KAH', 'difficulty': 2},
];

/// Vocabulary deck seed data
const decks = [
  {'id': 'basic_greetings', 'name_en': 'Basic Greetings', 'name_sw': 'Salamu za Msingi', 'name_tug': 'Chamgeinik', 'description': 'Essential greetings and polite expressions', 'icon': '\u{1F44B}', 'total_cards': 11, 'is_premium': false},
  {'id': 'numbers_1_10', 'name_en': 'Numbers 1-10', 'name_sw': 'Nambari 1-10', 'name_tug': 'Sigindeek 1-10', 'description': 'Count from one to ten in Tugen', 'icon': '\u{1F522}', 'total_cards': 10, 'is_premium': false},
  {'id': 'family_members', 'name_en': 'Family Members', 'name_sw': 'Wanafamilia', 'name_tug': 'Kapchi', 'description': 'Learn family relationship terms', 'icon': '\u{1F46A}', 'total_cards': 6, 'is_premium': false},
  {'id': 'food_drink', 'name_en': 'Food & Drink', 'name_sw': 'Chakula na Vinywaji', 'name_tug': 'Amak ak Beet', 'description': 'Common food and drink vocabulary', 'icon': '\u{1F35E}', 'total_cards': 5, 'is_premium': false},
];

/// Vocab cards — mirror the phrases for flashcard practice
const vocabCards = [
  // Greetings deck
  {'id': 'vc_g001', 'deck_id': 'basic_greetings', 'tugen': 'Chamgei', 'english': 'Hello / Greetings', 'swahili': 'Habari / Salamu', 'difficulty': 1},
  {'id': 'vc_g002', 'deck_id': 'basic_greetings', 'tugen': 'Chamgei inyee', 'english': 'Hello to you', 'swahili': 'Habari yako', 'difficulty': 1},
  {'id': 'vc_g003', 'deck_id': 'basic_greetings', 'tugen': 'Kagai mising', 'english': 'Very good / Fine', 'swahili': 'Nzuri sana', 'difficulty': 1},
  {'id': 'vc_g004', 'deck_id': 'basic_greetings', 'tugen': 'Sait', 'english': 'Thank you', 'swahili': 'Asante', 'difficulty': 1},
  {'id': 'vc_g005', 'deck_id': 'basic_greetings', 'tugen': 'Sait mising', 'english': 'Thank you very much', 'swahili': 'Asante sana', 'difficulty': 1},
  {'id': 'vc_g006', 'deck_id': 'basic_greetings', 'tugen': 'Kongoi', 'english': 'Please', 'swahili': 'Tafadhali', 'difficulty': 1},
  {'id': 'vc_g007', 'deck_id': 'basic_greetings', 'tugen': 'Sere', 'english': 'Goodbye', 'swahili': 'Kwaheri', 'difficulty': 1},
  {'id': 'vc_g008', 'deck_id': 'basic_greetings', 'tugen': 'Kabisa', 'english': 'You are welcome', 'swahili': 'Karibu', 'difficulty': 1},
  {'id': 'vc_g009', 'deck_id': 'basic_greetings', 'tugen': 'Ee', 'english': 'Yes', 'swahili': 'Ndiyo', 'difficulty': 1},
  {'id': 'vc_g010', 'deck_id': 'basic_greetings', 'tugen': 'Achicha', 'english': 'No', 'swahili': 'Hapana', 'difficulty': 1},
  {'id': 'vc_g011', 'deck_id': 'basic_greetings', 'tugen': 'Akonam ak beel?', 'english': 'How is your home?', 'swahili': 'Nyumba iko aje?', 'difficulty': 1},
  // Numbers deck
  {'id': 'vc_n001', 'deck_id': 'numbers_1_10', 'tugen': 'Agenge', 'english': 'One', 'swahili': 'Moja', 'difficulty': 1},
  {'id': 'vc_n002', 'deck_id': 'numbers_1_10', 'tugen': 'Aeng\'', 'english': 'Two', 'swahili': 'Mbili', 'difficulty': 1},
  {'id': 'vc_n003', 'deck_id': 'numbers_1_10', 'tugen': 'Somok', 'english': 'Three', 'swahili': 'Tatu', 'difficulty': 1},
  {'id': 'vc_n004', 'deck_id': 'numbers_1_10', 'tugen': 'Angwan', 'english': 'Four', 'swahili': 'Nne', 'difficulty': 1},
  {'id': 'vc_n005', 'deck_id': 'numbers_1_10', 'tugen': 'Muut', 'english': 'Five', 'swahili': 'Tano', 'difficulty': 1},
  {'id': 'vc_n006', 'deck_id': 'numbers_1_10', 'tugen': 'Lo', 'english': 'Six', 'swahili': 'Sita', 'difficulty': 1},
  {'id': 'vc_n007', 'deck_id': 'numbers_1_10', 'tugen': 'Tisap', 'english': 'Seven', 'swahili': 'Saba', 'difficulty': 1},
  {'id': 'vc_n008', 'deck_id': 'numbers_1_10', 'tugen': 'Sisit', 'english': 'Eight', 'swahili': 'Nane', 'difficulty': 1},
  {'id': 'vc_n009', 'deck_id': 'numbers_1_10', 'tugen': 'Sogol', 'english': 'Nine', 'swahili': 'Tisa', 'difficulty': 1},
  {'id': 'vc_n010', 'deck_id': 'numbers_1_10', 'tugen': 'Taman', 'english': 'Ten', 'swahili': 'Kumi', 'difficulty': 1},
  // Family deck
  {'id': 'vc_f001', 'deck_id': 'family_members', 'tugen': 'Papa', 'english': 'Father', 'swahili': 'Baba', 'difficulty': 1},
  {'id': 'vc_f002', 'deck_id': 'family_members', 'tugen': 'Mama', 'english': 'Mother', 'swahili': 'Mama', 'difficulty': 1},
  {'id': 'vc_f003', 'deck_id': 'family_members', 'tugen': 'Lakwa', 'english': 'Child', 'swahili': 'Mtoto', 'difficulty': 1},
  {'id': 'vc_f004', 'deck_id': 'family_members', 'tugen': 'Lagok', 'english': 'Children', 'swahili': 'Watoto', 'difficulty': 1},
  {'id': 'vc_f005', 'deck_id': 'family_members', 'tugen': 'Kogo', 'english': 'Grandmother', 'swahili': 'Bibi', 'difficulty': 1},
  {'id': 'vc_f006', 'deck_id': 'family_members', 'tugen': 'Kugo', 'english': 'Grandfather', 'swahili': 'Babu', 'difficulty': 1},
  // Food deck
  {'id': 'vc_fd001', 'deck_id': 'food_drink', 'tugen': 'Mursik', 'english': 'Fermented milk', 'swahili': 'Maziwa lala', 'difficulty': 1},
  {'id': 'vc_fd002', 'deck_id': 'food_drink', 'tugen': 'Kimyet', 'english': 'Food / Meal', 'swahili': 'Chakula', 'difficulty': 1},
  {'id': 'vc_fd003', 'deck_id': 'food_drink', 'tugen': 'Beet', 'english': 'Water', 'swahili': 'Maji', 'difficulty': 1},
  {'id': 'vc_fd004', 'deck_id': 'food_drink', 'tugen': 'Kimnyet', 'english': 'Ugali', 'swahili': 'Ugali', 'difficulty': 1},
  {'id': 'vc_fd005', 'deck_id': 'food_drink', 'tugen': 'Chegoek', 'english': 'Vegetables', 'swahili': 'Mboga', 'difficulty': 1},
];

/// Sample story
const stories = [
  {
    'id': 'story_hare_hyena',
    'title_en': 'The Hare and the Hyena',
    'title_sw': 'Sungura na Fisi',
    'title_tug': 'Chemoset ak Kimnyigei',
    'description': 'A traditional Tugen tale about cleverness',
    'duration_seconds': 180,
    'difficulty': 'beginner',
  },
];

/// Sample story segments
const storySegments = [
  {'id': 'seg_hh_001', 'story_id': 'story_hare_hyena', 'start_ms': 0, 'end_ms': 15000, 'tugen': 'Mi betut agenge, kiboisie Chemoset ak Kimnyigei kora.', 'english': 'One day, the Hare and the Hyena went walking together.', 'swahili': 'Siku moja, Sungura na Fisi walitembea pamoja.', 'sort_order': 1},
  {'id': 'seg_hh_002', 'story_id': 'story_hare_hyena', 'start_ms': 15000, 'end_ms': 30000, 'tugen': 'Kimwa Kimnyigei, "Amache kimyet, kaat amwa?"', 'english': 'The Hyena said, "I want food, where can I find it?"', 'swahili': 'Fisi alisema, "Ninataka chakula, nitapata wapi?"', 'sort_order': 2},
  {'id': 'seg_hh_003', 'story_id': 'story_hare_hyena', 'start_ms': 30000, 'end_ms': 45000, 'tugen': 'Kimwa Chemoset, "Wendi ak ana, anyorun ananam."', 'english': 'The Hare said, "Come with me, I know a place."', 'swahili': 'Sungura alisema, "Njoo nami, najua mahali."', 'sort_order': 3},
  {'id': 'seg_hh_004', 'story_id': 'story_hare_hyena', 'start_ms': 45000, 'end_ms': 60000, 'tugen': 'Kiwendi kobeel ne mi amak che chang.', 'english': 'They went to a homestead that had plenty of food.', 'swahili': 'Walikwenda nyumbani ambapo kulikuwa na chakula kingi.', 'sort_order': 4},
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
  print('To seed Supabase:');
  print('1. Run the schema SQL in supabase/schema.sql via the Supabase SQL Editor');
  print('2. Use the Supabase Dashboard > Table Editor to import rows');
  print('3. Or use the supabase-js client with service role key to insert programmatically');
  print('');
  print('Example with supabase-js (Node.js):');
  print('  const { createClient } = require("@supabase/supabase-js");');
  print('  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);');
  print('  await supabase.from("categories").upsert(categories);');
  print('  await supabase.from("phrases").upsert(phrases);');
  print('  // ... etc');
}
