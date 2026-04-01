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
/// NOTE: name_tug for 'body', 'time', 'emotions' are best-guess — verify with native speaker.
const categories = [
  {'id': 'greetings', 'name_en': 'Greetings', 'name_sw': 'Salamu', 'name_tug': 'Chamgei', 'icon': '\u{1F44B}', 'sort_order': 1},
  {'id': 'numbers', 'name_en': 'Numbers', 'name_sw': 'Nambari', 'name_tug': 'Sigindeek', 'icon': '\u{1F522}', 'sort_order': 2},
  {'id': 'family', 'name_en': 'Family', 'name_sw': 'Familia', 'name_tug': 'Kapchi', 'icon': '\u{1F46A}', 'sort_order': 3},
  {'id': 'food', 'name_en': 'Food & Market', 'name_sw': 'Chakula na Soko', 'name_tug': 'Amak ak Sindeet', 'icon': '\u{1F35E}', 'sort_order': 4},
  {'id': 'travel', 'name_en': 'Travel & Directions', 'name_sw': 'Safari na Mwelekeo', 'name_tug': 'Boisiet', 'icon': '\u{1F697}', 'sort_order': 5},
  {'id': 'daily', 'name_en': 'Daily Life', 'name_sw': 'Maisha ya Kila Siku', 'name_tug': 'Soboniik', 'icon': '\u{2600}', 'sort_order': 6},
  {'id': 'animals', 'name_en': 'Animals & Nature', 'name_sw': 'Wanyama na Mazingira', 'name_tug': 'Tisiik ak Emet', 'icon': '\u{1F98A}', 'sort_order': 7},
  {'id': 'proverbs', 'name_en': 'Proverbs & Sayings', 'name_sw': 'Methali na Misemo', 'name_tug': 'Ng\'aleekab Konoiik', 'icon': '\u{1F4DC}', 'sort_order': 8},
  // New categories — Tugen names need native speaker verification
  {'id': 'body', 'name_en': 'Body Parts', 'name_sw': 'Sehemu za Mwili', 'name_tug': 'Chesik', 'icon': '\u{1F464}', 'sort_order': 9},
  {'id': 'time', 'name_en': 'Time & Calendar', 'name_sw': 'Wakati na Kalenda', 'name_tug': 'Betusiek', 'icon': '\u{1F4C5}', 'sort_order': 10},
  {'id': 'emotions', 'name_en': 'Emotions & Love', 'name_sw': 'Hisia na Upendo', 'name_tug': 'Chamyet', 'icon': '\u{1F970}', 'sort_order': 11},
];

/// Phrase seed data
const phrases = [
  // ── GREETINGS ─────────────────────────────────────────────────────────────
  {'id': 'g001', 'category_id': 'greetings', 'tugen': 'Chamgei', 'english': 'Hello / Greetings', 'swahili': 'Habari / Salamu', 'pronunciation': 'cham-GEY', 'difficulty': 1, 'notes': 'Universal Kalenjin greeting, used any time of day'},
  {'id': 'g002', 'category_id': 'greetings', 'tugen': 'Chamgei inyee', 'english': 'Hello to you', 'swahili': 'Habari yako', 'pronunciation': 'cham-GEY in-YEE', 'difficulty': 1},
  {'id': 'g003', 'category_id': 'greetings', 'tugen': 'Akonam ak beel?', 'english': 'How is your home?', 'swahili': 'Nyumba iko aje?', 'pronunciation': 'ah-KOH-nam ak BEEL', 'difficulty': 1, 'notes': 'Common way to ask "how are you?" — asking about one\'s household'},
  {'id': 'g004', 'category_id': 'greetings', 'tugen': 'Kagai mising', 'english': 'Very good / Fine', 'swahili': 'Nzuri sana', 'pronunciation': 'kah-GUY mih-SING', 'difficulty': 1},
  {'id': 'g005', 'category_id': 'greetings', 'tugen': 'Sait', 'english': 'Thank you', 'swahili': 'Asante', 'pronunciation': 'SIGHT', 'difficulty': 1},
  {'id': 'g006', 'category_id': 'greetings', 'tugen': 'Sait mising', 'english': 'Thank you very much', 'swahili': 'Asante sana', 'pronunciation': 'SIGHT mih-SING', 'difficulty': 1},
  {'id': 'g007', 'category_id': 'greetings', 'tugen': 'Kongoi', 'english': 'Please', 'swahili': 'Tafadhali', 'pronunciation': 'kon-GOY', 'difficulty': 1, 'notes': 'Some sources list as "Thank you" — verify with native speaker'},
  {'id': 'g008', 'category_id': 'greetings', 'tugen': 'Sere', 'english': 'Goodbye', 'swahili': 'Kwaheri', 'pronunciation': 'SEH-reh', 'difficulty': 1},
  {'id': 'g009', 'category_id': 'greetings', 'tugen': 'Kabisa', 'english': 'You are welcome', 'swahili': 'Karibu', 'pronunciation': 'kah-BEE-sah', 'difficulty': 1},
  {'id': 'g010', 'category_id': 'greetings', 'tugen': 'Ee', 'english': 'Yes', 'swahili': 'Ndiyo', 'pronunciation': 'EH', 'difficulty': 1},
  {'id': 'g011', 'category_id': 'greetings', 'tugen': 'Achicha', 'english': 'No', 'swahili': 'Hapana', 'pronunciation': 'ah-CHEE-cha', 'difficulty': 1},

  // ── NUMBERS (1–20) ────────────────────────────────────────────────────────
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
  {'id': 'n011', 'category_id': 'numbers', 'tugen': 'Taman agenge', 'english': 'Eleven', 'swahili': 'Kumi na moja', 'pronunciation': 'TAH-man ah-GENG-eh', 'difficulty': 2},
  {'id': 'n012', 'category_id': 'numbers', 'tugen': 'Taman ak aeng\'', 'english': 'Twelve', 'swahili': 'Kumi na mbili', 'pronunciation': 'TAH-man ak AH-eng', 'difficulty': 2},
  {'id': 'n013', 'category_id': 'numbers', 'tugen': 'Sosom', 'english': 'Thirteen', 'swahili': 'Kumi na tatu', 'pronunciation': 'SOH-som', 'difficulty': 2, 'notes': 'Special compound form — not a regular Taman ak Somok pattern'},
  {'id': 'n014', 'category_id': 'numbers', 'tugen': 'Taman ak angwan', 'english': 'Fourteen', 'swahili': 'Kumi na nne', 'pronunciation': 'TAH-man ak ANG-wan', 'difficulty': 2},
  {'id': 'n015', 'category_id': 'numbers', 'tugen': 'Taman ak muut', 'english': 'Fifteen', 'swahili': 'Kumi na tano', 'pronunciation': 'TAH-man ak MOOT', 'difficulty': 2},
  {'id': 'n016', 'category_id': 'numbers', 'tugen': 'Taman ak lo', 'english': 'Sixteen', 'swahili': 'Kumi na sita', 'pronunciation': 'TAH-man ak LOH', 'difficulty': 2},
  {'id': 'n017', 'category_id': 'numbers', 'tugen': 'Taman ak tisap', 'english': 'Seventeen', 'swahili': 'Kumi na saba', 'pronunciation': 'TAH-man ak TIH-sap', 'difficulty': 2},
  {'id': 'n018', 'category_id': 'numbers', 'tugen': 'Taman ak sisit', 'english': 'Eighteen', 'swahili': 'Kumi na nane', 'pronunciation': 'TAH-man ak SIH-sit', 'difficulty': 2},
  {'id': 'n019', 'category_id': 'numbers', 'tugen': 'Taman ak sogol', 'english': 'Nineteen', 'swahili': 'Kumi na tisa', 'pronunciation': 'TAH-man ak SOH-gol', 'difficulty': 2},
  {'id': 'n020', 'category_id': 'numbers', 'tugen': 'Tuptem', 'english': 'Twenty', 'swahili': 'Ishirini', 'pronunciation': 'TOOP-tem', 'difficulty': 2},

  // ── FAMILY ────────────────────────────────────────────────────────────────
  {'id': 'f001', 'category_id': 'family', 'tugen': 'Papa', 'english': 'Father', 'swahili': 'Baba', 'pronunciation': 'PAH-pah', 'difficulty': 1},
  {'id': 'f002', 'category_id': 'family', 'tugen': 'Mama', 'english': 'Mother', 'swahili': 'Mama', 'pronunciation': 'MAH-mah', 'difficulty': 1},
  {'id': 'f003', 'category_id': 'family', 'tugen': 'Lakwa', 'english': 'Child', 'swahili': 'Mtoto', 'pronunciation': 'LAK-wah', 'difficulty': 1},
  {'id': 'f004', 'category_id': 'family', 'tugen': 'Lagok', 'english': 'Children', 'swahili': 'Watoto', 'pronunciation': 'lah-GOK', 'difficulty': 1},
  {'id': 'f005', 'category_id': 'family', 'tugen': 'Kogo', 'english': 'Grandmother', 'swahili': 'Bibi', 'pronunciation': 'KOH-goh', 'difficulty': 1},
  {'id': 'f006', 'category_id': 'family', 'tugen': 'Kugo', 'english': 'Grandfather', 'swahili': 'Babu', 'pronunciation': 'KOO-goh', 'difficulty': 1},
  {'id': 'f007', 'category_id': 'family', 'tugen': 'Werit', 'english': 'Son', 'swahili': 'Mwana wa kiume', 'pronunciation': 'WEH-rit', 'difficulty': 1},
  {'id': 'f008', 'category_id': 'family', 'tugen': 'Chepto', 'english': 'Daughter / Girl', 'swahili': 'Binti / Msichana', 'pronunciation': 'CHEP-toh', 'difficulty': 1},
  {'id': 'f009', 'category_id': 'family', 'tugen': 'Ng\'etet', 'english': 'Boy', 'swahili': 'Mvulana', 'pronunciation': 'ng-EH-tet', 'difficulty': 1},
  {'id': 'f010', 'category_id': 'family', 'tugen': 'Abule', 'english': 'Uncle', 'swahili': 'Mjomba', 'pronunciation': 'ah-BOO-leh', 'difficulty': 2},
  {'id': 'f011', 'category_id': 'family', 'tugen': 'Senge', 'english': 'Aunt', 'swahili': 'Shangazi', 'pronunciation': 'SENG-eh', 'difficulty': 2},
  {'id': 'f012', 'category_id': 'family', 'tugen': 'Osotio', 'english': 'Wife', 'swahili': 'Mke', 'pronunciation': 'oh-SOH-tee-oh', 'difficulty': 2},
  {'id': 'f013', 'category_id': 'family', 'tugen': 'Moning\'otiot', 'english': 'Husband', 'swahili': 'Mume', 'pronunciation': 'moh-ning-OH-tee-ot', 'difficulty': 2},
  {'id': 'f014', 'category_id': 'family', 'tugen': 'Muren', 'english': 'Man', 'swahili': 'Mwanaume', 'pronunciation': 'MOO-ren', 'difficulty': 1},
  {'id': 'f015', 'category_id': 'family', 'tugen': 'Kwondo', 'english': 'Woman', 'swahili': 'Mwanamke', 'pronunciation': 'KWON-doh', 'difficulty': 1},
  {'id': 'f016', 'category_id': 'family', 'tugen': 'Taita', 'english': 'First born', 'swahili': 'Mzaliwa wa kwanza', 'pronunciation': 'tah-EE-tah', 'difficulty': 2, 'notes': 'First child holds special cultural status in Tugen society'},

  // ── FOOD & MARKET ─────────────────────────────────────────────────────────
  {'id': 'fd001', 'category_id': 'food', 'tugen': 'Mursik', 'english': 'Fermented milk', 'swahili': 'Maziwa lala', 'pronunciation': 'MOOR-sik', 'difficulty': 1, 'notes': 'Traditional Kalenjin fermented milk drink, culturally important'},
  {'id': 'fd002', 'category_id': 'food', 'tugen': 'Kimyet', 'english': 'Food / Meal', 'swahili': 'Chakula', 'pronunciation': 'KIM-yet', 'difficulty': 1},
  {'id': 'fd003', 'category_id': 'food', 'tugen': 'Beet', 'english': 'Water', 'swahili': 'Maji', 'pronunciation': 'BEET', 'difficulty': 1},
  {'id': 'fd004', 'category_id': 'food', 'tugen': 'Kimnyet', 'english': 'Ugali (maize flour)', 'swahili': 'Ugali', 'pronunciation': 'KIM-nyet', 'difficulty': 1},
  {'id': 'fd005', 'category_id': 'food', 'tugen': 'Chegoek', 'english': 'Vegetables', 'swahili': 'Mboga', 'pronunciation': 'cheh-GOEK', 'difficulty': 1},
  {'id': 'fd006', 'category_id': 'food', 'tugen': 'Pendo', 'english': 'Meat', 'swahili': 'Nyama', 'pronunciation': 'PEN-doh', 'difficulty': 1},
  {'id': 'fd007', 'category_id': 'food', 'tugen': 'Chego', 'english': 'Milk', 'swahili': 'Maziwa', 'pronunciation': 'CHEH-goh', 'difficulty': 1},
  {'id': 'fd008', 'category_id': 'food', 'tugen': 'Chaik', 'english': 'Tea', 'swahili': 'Chai', 'pronunciation': 'CHAYK', 'difficulty': 1},
  {'id': 'fd009', 'category_id': 'food', 'tugen': 'Kaweek', 'english': 'Coffee', 'swahili': 'Kahawa', 'pronunciation': 'kah-WEEK', 'difficulty': 1},
  {'id': 'fd010', 'category_id': 'food', 'tugen': 'Sutek', 'english': 'Soup', 'swahili': 'Supu', 'pronunciation': 'SOO-tek', 'difficulty': 1},
  {'id': 'fd011', 'category_id': 'food', 'tugen': 'Samakiat', 'english': 'Fish', 'swahili': 'Samaki', 'pronunciation': 'sah-MAK-ee-at', 'difficulty': 1},
  {'id': 'fd012', 'category_id': 'food', 'tugen': 'Pandek', 'english': 'Maize', 'swahili': 'Mahindi', 'pronunciation': 'PAN-dek', 'difficulty': 1},
  {'id': 'fd013', 'category_id': 'food', 'tugen': 'Rangorik', 'english': 'Porridge', 'swahili': 'Uji', 'pronunciation': 'ran-GOH-rik', 'difficulty': 1},
  {'id': 'fd014', 'category_id': 'food', 'tugen': 'Ata?', 'english': 'How much?', 'swahili': 'Bei gani?', 'pronunciation': 'AH-tah', 'difficulty': 2},
  {'id': 'fd015', 'category_id': 'food', 'tugen': 'Beit ne mi barak', 'english': 'It is expensive', 'swahili': 'Ni ghali', 'pronunciation': 'BAYT neh mee BAH-rak', 'difficulty': 2},
  {'id': 'fd016', 'category_id': 'food', 'tugen': 'Beit ne mi ng\'wenyi', 'english': 'It is cheap', 'swahili': 'Ni rahisi', 'pronunciation': 'BAYT neh mee ng-WEH-nyee', 'difficulty': 2},

  // ── DAILY LIFE ────────────────────────────────────────────────────────────
  {'id': 'd001', 'category_id': 'daily', 'tugen': 'Tai ata?', 'english': 'What time is it?', 'swahili': 'Ni saa ngapi?', 'pronunciation': 'TUY ah-TAH', 'difficulty': 2},
  {'id': 'd002', 'category_id': 'daily', 'tugen': 'Inendet ne oo', 'english': 'It is morning', 'swahili': 'Ni asubuhi', 'pronunciation': 'ih-NEN-det neh OO', 'difficulty': 2},
  {'id': 'd003', 'category_id': 'daily', 'tugen': 'Amache', 'english': 'I want', 'swahili': 'Ninataka', 'pronunciation': 'ah-MAH-cheh', 'difficulty': 2},
  {'id': 'd004', 'category_id': 'daily', 'tugen': 'Wendi kaa?', 'english': 'Where are you going?', 'swahili': 'Unakwenda wapi?', 'pronunciation': 'WEN-dee KAH', 'difficulty': 2},
  {'id': 'd005', 'category_id': 'daily', 'tugen': 'Chamngee nebo karon', 'english': 'Good morning', 'swahili': 'Habari za asubuhi', 'pronunciation': 'cham-NGEE neh-BOH kah-RON', 'difficulty': 1},
  {'id': 'd006', 'category_id': 'daily', 'tugen': 'Chamngee nebo bet', 'english': 'Good afternoon', 'swahili': 'Habari za mchana', 'pronunciation': 'cham-NGEE neh-BOH BET', 'difficulty': 1},
  {'id': 'd007', 'category_id': 'daily', 'tugen': 'Chamngee nebo koskoliny', 'english': 'Good evening', 'swahili': 'Habari za jioni', 'pronunciation': 'cham-NGEE neh-BOH kos-KOH-lee-ny', 'difficulty': 1},
  {'id': 'd008', 'category_id': 'daily', 'tugen': 'Iyamune?', 'english': 'How are you?', 'swahili': 'Habari yako?', 'pronunciation': 'ee-yah-MOO-neh', 'difficulty': 1},
  {'id': 'd009', 'category_id': 'daily', 'tugen': 'Achamegee', 'english': 'I am fine', 'swahili': 'Niko salama', 'pronunciation': 'ah-chah-MEH-gee', 'difficulty': 1},
  {'id': 'd010', 'category_id': 'daily', 'tugen': 'Mangen', 'english': 'I don\'t know', 'swahili': 'Sijui', 'pronunciation': 'MAH-ngen', 'difficulty': 2},
  {'id': 'd011', 'category_id': 'daily', 'tugen': 'Kararan', 'english': 'It\'s okay', 'swahili': 'Sawa', 'pronunciation': 'kah-RAH-ran', 'difficulty': 1},
  {'id': 'd012', 'category_id': 'daily', 'tugen': 'Rani', 'english': 'Today', 'swahili': 'Leo', 'pronunciation': 'RAH-nee', 'difficulty': 1},
  {'id': 'd013', 'category_id': 'daily', 'tugen': 'Mutai', 'english': 'Tomorrow', 'swahili': 'Kesho', 'pronunciation': 'MOO-tai', 'difficulty': 1},
  {'id': 'd014', 'category_id': 'daily', 'tugen': 'Kainetneng\'ung\' ko ng\'o?', 'english': 'What is your name?', 'swahili': 'Jina lako ni nani?', 'pronunciation': 'kah-ee-net-NENG-ung koh NG-oh', 'difficulty': 2},

  // ── TRAVEL & DIRECTIONS (was empty) ──────────────────────────────────────
  {'id': 't001', 'category_id': 'travel', 'tugen': 'Kongasis', 'english': 'East', 'swahili': 'Mashariki', 'pronunciation': 'kon-GAH-sis', 'difficulty': 2},
  {'id': 't002', 'category_id': 'travel', 'tugen': 'Cherongo', 'english': 'West', 'swahili': 'Magharibi', 'pronunciation': 'cheh-RON-goh', 'difficulty': 2},
  {'id': 't003', 'category_id': 'travel', 'tugen': 'Murot katam', 'english': 'North', 'swahili': 'Kaskazini', 'pronunciation': 'MOO-rot KAH-tam', 'difficulty': 2},
  {'id': 't004', 'category_id': 'travel', 'tugen': 'Murot taai', 'english': 'South', 'swahili': 'Kusini', 'pronunciation': 'MOO-rot TAH-ee', 'difficulty': 2},
  {'id': 't005', 'category_id': 'travel', 'tugen': 'Eut ap katam', 'english': 'Left', 'swahili': 'Kushoto', 'pronunciation': 'EH-oot ap KAH-tam', 'difficulty': 1},
  {'id': 't006', 'category_id': 'travel', 'tugen': 'Eut ap taai', 'english': 'Right', 'swahili': 'Kulia', 'pronunciation': 'EH-oot ap TAH-ee', 'difficulty': 1},
  {'id': 't007', 'category_id': 'travel', 'tugen': 'Oret', 'english': 'Road / Path', 'swahili': 'Barabara / Njia', 'pronunciation': 'OH-ret', 'difficulty': 1},
  {'id': 't008', 'category_id': 'travel', 'tugen': 'Imieno?', 'english': 'Where are you?', 'swahili': 'Uko wapi?', 'pronunciation': 'ee-mee-EH-noh', 'difficulty': 2},
  {'id': 't009', 'category_id': 'travel', 'tugen': 'Iwendi ano?', 'english': 'Where are you going?', 'swahili': 'Unakwenda wapi?', 'pronunciation': 'ee-WEN-dee AH-noh', 'difficulty': 2},
  {'id': 't010', 'category_id': 'travel', 'tugen': 'Ipano?', 'english': 'Where are you from?', 'swahili': 'Unatoka wapi?', 'pronunciation': 'ee-PAH-noh', 'difficulty': 2},
  {'id': 't011', 'category_id': 'travel', 'tugen': 'Imenye ano?', 'english': 'Where do you live?', 'swahili': 'Unaishi wapi?', 'pronunciation': 'ee-MEN-yeh AH-noh', 'difficulty': 2},
  {'id': 't012', 'category_id': 'travel', 'tugen': 'Inekit?', 'english': 'Are you close by?', 'swahili': 'Uko karibu?', 'pronunciation': 'ee-NEH-kit', 'difficulty': 2},

  // ── ANIMALS & NATURE (was empty) ─────────────────────────────────────────
  // Wild animals
  {'id': 'a001', 'category_id': 'animals', 'tugen': 'Ng\'etundo', 'english': 'Lion', 'swahili': 'Simba', 'pronunciation': 'ng-eh-TOON-doh', 'difficulty': 1},
  {'id': 'a002', 'category_id': 'animals', 'tugen': 'Cheplanget', 'english': 'Leopard', 'swahili': 'Chui', 'pronunciation': 'chep-LANG-et', 'difficulty': 2},
  {'id': 'a003', 'category_id': 'animals', 'tugen': 'Beliot', 'english': 'Elephant', 'swahili': 'Tembo', 'pronunciation': 'beh-LEE-ot', 'difficulty': 1},
  {'id': 'a004', 'category_id': 'animals', 'tugen': 'Soet', 'english': 'Buffalo', 'swahili': 'Nyati', 'pronunciation': 'SOH-et', 'difficulty': 1},
  {'id': 'a005', 'category_id': 'animals', 'tugen': 'Leitigo', 'english': 'Zebra', 'swahili': 'Punda milia', 'pronunciation': 'leh-TEE-goh', 'difficulty': 2},
  {'id': 'a006', 'category_id': 'animals', 'tugen': 'Kimagetiet', 'english': 'Hyena', 'swahili': 'Fisi', 'pronunciation': 'kee-mah-GET-ee-et', 'difficulty': 2},
  {'id': 'a007', 'category_id': 'animals', 'tugen': 'Moset', 'english': 'Monkey', 'swahili': 'Tumbili', 'pronunciation': 'MOH-set', 'difficulty': 2},
  {'id': 'a008', 'category_id': 'animals', 'tugen': 'Cherekweny', 'english': 'Hare', 'swahili': 'Sungura', 'pronunciation': 'cheh-reh-KWEN-yee', 'difficulty': 2},
  {'id': 'a009', 'category_id': 'animals', 'tugen': 'Munywet', 'english': 'Snake', 'swahili': 'Nyoka', 'pronunciation': 'MOON-ywet', 'difficulty': 1},
  {'id': 'a010', 'category_id': 'animals', 'tugen': 'Boinet', 'english': 'Gazelle', 'swahili': 'Swala', 'pronunciation': 'BOY-net', 'difficulty': 2},
  // Domestic animals
  {'id': 'a011', 'category_id': 'animals', 'tugen': 'Teta', 'english': 'Cow', 'swahili': 'Ng\'ombe', 'pronunciation': 'TEH-tah', 'difficulty': 1, 'notes': 'Cattle are central to Tugen culture and economy'},
  {'id': 'a012', 'category_id': 'animals', 'tugen': 'Artet', 'english': 'Goat', 'swahili': 'Mbuzi', 'pronunciation': 'AR-tet', 'difficulty': 1},
  {'id': 'a013', 'category_id': 'animals', 'tugen': 'Ngechiryet', 'english': 'Sheep', 'swahili': 'Kondoo', 'pronunciation': 'ngeh-CHEER-yet', 'difficulty': 2},
  {'id': 'a014', 'category_id': 'animals', 'tugen': 'Ingokyet', 'english': 'Chicken', 'swahili': 'Kuku', 'pronunciation': 'in-GOK-yet', 'difficulty': 1},
  {'id': 'a015', 'category_id': 'animals', 'tugen': 'Kiptawirit', 'english': 'Dog', 'swahili': 'Mbwa', 'pronunciation': 'kip-tah-WEE-rit', 'difficulty': 2},
  {'id': 'a016', 'category_id': 'animals', 'tugen': 'Pakeet', 'english': 'Cat', 'swahili': 'Paka', 'pronunciation': 'pah-KEET', 'difficulty': 1},
  {'id': 'a017', 'category_id': 'animals', 'tugen': 'Taratiet', 'english': 'Bird', 'swahili': 'Ndege', 'pronunciation': 'tah-RAH-tee-et', 'difficulty': 1},
  // Nature & celestial
  {'id': 'a018', 'category_id': 'animals', 'tugen': 'Asista', 'english': 'Sun', 'swahili': 'Jua', 'pronunciation': 'ah-SIS-tah', 'difficulty': 1, 'notes': 'Asista also means God — the sun is sacred in Kalenjin tradition'},
  {'id': 'a019', 'category_id': 'animals', 'tugen': 'Arawet', 'english': 'Moon', 'swahili': 'Mwezi', 'pronunciation': 'ah-RAH-wet', 'difficulty': 1},
  {'id': 'a020', 'category_id': 'animals', 'tugen': 'Ropta', 'english': 'Rain', 'swahili': 'Mvua', 'pronunciation': 'ROP-tah', 'difficulty': 1},
  {'id': 'a021', 'category_id': 'animals', 'tugen': 'Keet', 'english': 'Tree', 'swahili': 'Mti', 'pronunciation': 'KEET', 'difficulty': 1},
  {'id': 'a022', 'category_id': 'animals', 'tugen': 'Kipsengwet', 'english': 'Sky / Heaven', 'swahili': 'Anga / Mbinguni', 'pronunciation': 'kip-SENG-wet', 'difficulty': 2},

  // ── PROVERBS & SAYINGS (was empty) ───────────────────────────────────────
  {'id': 'p001', 'category_id': 'proverbs', 'tugen': 'Ingen tarit konyin', 'english': 'A bird knows its own house', 'swahili': 'Ndege anajua nyumba yake', 'difficulty': 3, 'notes': 'Everyone knows where they belong; home is instinctive'},
  {'id': 'p002', 'category_id': 'proverbs', 'tugen': 'Mabarei kuinet ab teta moitanyi', 'english': 'A cow\'s horn does not hurt its own calf', 'swahili': 'Pembe ya ng\'ombe haumizi ndama wake', 'difficulty': 3, 'notes': 'Parents may seem harsh but they never truly harm their children'},
  {'id': 'p003', 'category_id': 'proverbs', 'tugen': 'Chepkisas ko tatun kechome', 'english': 'The despised one will eventually be honored', 'swahili': 'Aliyedharauliwa ataheshimiwa', 'difficulty': 3, 'notes': 'Encouragement for those who are overlooked or underestimated'},
  {'id': 'p004', 'category_id': 'proverbs', 'tugen': 'Kibire mat koloo', 'english': 'Solve a problem while it is still small', 'swahili': 'Tatua tatizo likiwa dogo', 'difficulty': 3, 'notes': 'Address issues early before they grow; an ounce of prevention'},
  {'id': 'p005', 'category_id': 'proverbs', 'tugen': 'Mabenen bei tororot', 'english': 'Suffering is not everlasting', 'swahili': 'Maumivu hayakaa milele', 'difficulty': 3, 'notes': 'A saying of comfort and resilience — hard times will pass'},
  {'id': 'p006', 'category_id': 'proverbs', 'tugen': 'Kibendi ban chepkokoch', 'english': 'Be slow and sure in life', 'swahili': 'Kuwa polepole na imara maishani', 'difficulty': 3, 'notes': 'Patience and steadiness are valued over haste'},
  {'id': 'p007', 'category_id': 'proverbs', 'tugen': 'Korom ngetundo omo ome arekyik', 'english': 'The lion does not eat its own young', 'swahili': 'Simba hali watoto wake', 'difficulty': 3, 'notes': 'Blood protects blood; family loyalty runs deep'},
  {'id': 'p008', 'category_id': 'proverbs', 'tugen': 'Kigongen met batalamtagat', 'english': 'A journey of a thousand miles begins with a single step', 'swahili': 'Safari ya maili elfu huanza na hatua moja', 'difficulty': 4, 'notes': 'Even the greatest achievement begins small — just start'},
  {'id': 'p009', 'category_id': 'proverbs', 'tugen': 'Kiseten tai ak katam', 'english': 'Try every means — left hand and right', 'swahili': 'Jaribu njia zote kufikia lengo lako', 'difficulty': 3, 'notes': 'Use all available resources; leave no stone unturned'},
  {'id': 'p010', 'category_id': 'proverbs', 'tugen': 'Mapatien tisian tany', 'english': 'A cow never lacks a spot', 'swahili': 'Ng\'ombe hana pasipo madoa', 'difficulty': 3, 'notes': 'Every person and community has both strengths and flaws'},

  // ── BODY PARTS (new category) ─────────────────────────────────────────────
  {'id': 'b001', 'category_id': 'body', 'tugen': 'Metit', 'english': 'Head', 'swahili': 'Kichwa', 'pronunciation': 'MEH-tit', 'difficulty': 1},
  {'id': 'b002', 'category_id': 'body', 'tugen': 'Togoch', 'english': 'Face', 'swahili': 'Uso', 'pronunciation': 'TOH-goch', 'difficulty': 1},
  {'id': 'b003', 'category_id': 'body', 'tugen': 'Iitit', 'english': 'Ear', 'swahili': 'Sikio', 'pronunciation': 'EE-tit', 'difficulty': 1},
  {'id': 'b004', 'category_id': 'body', 'tugen': 'Konda', 'english': 'Eye', 'swahili': 'Jicho', 'pronunciation': 'KON-dah', 'difficulty': 1},
  {'id': 'b005', 'category_id': 'body', 'tugen': 'Seruu', 'english': 'Nose', 'swahili': 'Pua', 'pronunciation': 'SEH-roo', 'difficulty': 1},
  {'id': 'b006', 'category_id': 'body', 'tugen': 'Kutit', 'english': 'Mouth', 'swahili': 'Mdomo', 'pronunciation': 'KOO-tit', 'difficulty': 1},
  {'id': 'b007', 'category_id': 'body', 'tugen': 'Eut', 'english': 'Arm / Hand', 'swahili': 'Mkono', 'pronunciation': 'EH-oot', 'difficulty': 1},
  {'id': 'b008', 'category_id': 'body', 'tugen': 'Keldo', 'english': 'Leg', 'swahili': 'Mguu', 'pronunciation': 'KEL-doh', 'difficulty': 1},
  {'id': 'b009', 'category_id': 'body', 'tugen': 'Moet', 'english': 'Stomach', 'swahili': 'Tumbo', 'pronunciation': 'MOH-et', 'difficulty': 1},
  {'id': 'b010', 'category_id': 'body', 'tugen': 'Siiyet', 'english': 'Finger', 'swahili': 'Kidole', 'pronunciation': 'see-YET', 'difficulty': 2},
  {'id': 'b011', 'category_id': 'body', 'tugen': 'Sumek', 'english': 'Hair', 'swahili': 'Nywele', 'pronunciation': 'SOO-mek', 'difficulty': 1},
  {'id': 'b012', 'category_id': 'body', 'tugen': 'Patai', 'english': 'Back', 'swahili': 'Mgongo', 'pronunciation': 'pah-TYE', 'difficulty': 2},
  {'id': 'b013', 'category_id': 'body', 'tugen': 'Keldeit', 'english': 'Tooth', 'swahili': 'Jino', 'pronunciation': 'KEL-dayt', 'difficulty': 2},
  {'id': 'b014', 'category_id': 'body', 'tugen': 'Ngelyepta', 'english': 'Tongue', 'swahili': 'Ulimi', 'pronunciation': 'ngeh-LYEP-tah', 'difficulty': 2},

  // ── TIME & CALENDAR (new category) ───────────────────────────────────────
  {'id': 'tm001', 'category_id': 'time', 'tugen': 'Kotisap', 'english': 'Sunday', 'swahili': 'Jumapili', 'pronunciation': 'koh-TIH-sap', 'difficulty': 2},
  {'id': 'tm002', 'category_id': 'time', 'tugen': 'Kotaai', 'english': 'Monday', 'swahili': 'Jumatatu', 'pronunciation': 'koh-TAH-ee', 'difficulty': 2},
  {'id': 'tm003', 'category_id': 'time', 'tugen': 'Koaeng\'', 'english': 'Tuesday', 'swahili': 'Jumanne', 'pronunciation': 'koh-AH-eng', 'difficulty': 2},
  {'id': 'tm004', 'category_id': 'time', 'tugen': 'Kosomok', 'english': 'Wednesday', 'swahili': 'Jumatano', 'pronunciation': 'koh-SOH-mok', 'difficulty': 2},
  {'id': 'tm005', 'category_id': 'time', 'tugen': 'Koang\'wan', 'english': 'Thursday', 'swahili': 'Alhamisi', 'pronunciation': 'koh-ANG-wan', 'difficulty': 2},
  {'id': 'tm006', 'category_id': 'time', 'tugen': 'Komuut', 'english': 'Friday', 'swahili': 'Ijumaa', 'pronunciation': 'koh-MOOT', 'difficulty': 2},
  {'id': 'tm007', 'category_id': 'time', 'tugen': 'Kolo', 'english': 'Saturday', 'swahili': 'Jumamosi', 'pronunciation': 'KOH-loh', 'difficulty': 2},
  {'id': 'tm008', 'category_id': 'time', 'tugen': 'Rani', 'english': 'Today', 'swahili': 'Leo', 'pronunciation': 'RAH-nee', 'difficulty': 1},
  {'id': 'tm009', 'category_id': 'time', 'tugen': 'Mutai', 'english': 'Tomorrow', 'swahili': 'Kesho', 'pronunciation': 'MOO-tai', 'difficulty': 1},
  {'id': 'tm010', 'category_id': 'time', 'tugen': 'Betut', 'english': 'Day', 'swahili': 'Siku', 'pronunciation': 'BEH-toot', 'difficulty': 1},
  {'id': 'tm011', 'category_id': 'time', 'tugen': 'Karon', 'english': 'Morning', 'swahili': 'Asubuhi', 'pronunciation': 'KAH-ron', 'difficulty': 1},
  {'id': 'tm012', 'category_id': 'time', 'tugen': 'Bet', 'english': 'Afternoon / Midday', 'swahili': 'Mchana', 'pronunciation': 'BET', 'difficulty': 1},
  {'id': 'tm013', 'category_id': 'time', 'tugen': 'Koskoliny', 'english': 'Evening', 'swahili': 'Jioni', 'pronunciation': 'kos-KOH-lee-ny', 'difficulty': 1},
  {'id': 'tm014', 'category_id': 'time', 'tugen': 'Runet', 'english': 'Night', 'swahili': 'Usiku', 'pronunciation': 'ROO-net', 'difficulty': 1},
  {'id': 'tm015', 'category_id': 'time', 'tugen': 'Kenyit', 'english': 'Year', 'swahili': 'Mwaka', 'pronunciation': 'KEH-nyit', 'difficulty': 2},

  // ── EMOTIONS & LOVE (new category) ───────────────────────────────────────
  {'id': 'em001', 'category_id': 'emotions', 'tugen': 'Achamin', 'english': 'I love you', 'swahili': 'Nakupenda', 'pronunciation': 'ah-CHAH-min', 'difficulty': 1},
  {'id': 'em002', 'category_id': 'emotions', 'tugen': 'Achamin maan', 'english': 'I love you so much', 'swahili': 'Nakupenda sana', 'pronunciation': 'ah-CHAH-min MAHN', 'difficulty': 1},
  {'id': 'em003', 'category_id': 'emotions', 'tugen': 'Kia kosanin', 'english': 'I miss you', 'swahili': 'Nakukumbuka', 'pronunciation': 'kee-ah koh-SAH-nin', 'difficulty': 2},
  {'id': 'em004', 'category_id': 'emotions', 'tugen': 'Chamyet', 'english': 'Love', 'swahili': 'Upendo', 'pronunciation': 'CHAM-yet', 'difficulty': 1},
  {'id': 'em005', 'category_id': 'emotions', 'tugen': 'Poiboiyet', 'english': 'Joy', 'swahili': 'Furaha', 'pronunciation': 'poy-BOY-yet', 'difficulty': 2},
  {'id': 'em006', 'category_id': 'emotions', 'tugen': 'Kaalyeet', 'english': 'Peace', 'swahili': 'Amani', 'pronunciation': 'kah-al-YEET', 'difficulty': 2},
  {'id': 'em007', 'category_id': 'emotions', 'tugen': 'Muitaet', 'english': 'Patience', 'swahili': 'Uvumilivu', 'pronunciation': 'moo-ee-TAH-et', 'difficulty': 3},
  {'id': 'em008', 'category_id': 'emotions', 'tugen': 'Talasyet', 'english': 'Kindness', 'swahili': 'Wema', 'pronunciation': 'tah-LAS-yet', 'difficulty': 3},
  {'id': 'em009', 'category_id': 'emotions', 'tugen': 'Kanget', 'english': 'I am tired', 'swahili': 'Nimechoka', 'pronunciation': 'KANG-et', 'difficulty': 2},
  {'id': 'em010', 'category_id': 'emotions', 'tugen': 'Mutyoo', 'english': 'I am sorry', 'swahili': 'Samahani', 'pronunciation': 'moo-TYOH', 'difficulty': 1},
  {'id': 'em011', 'category_id': 'emotions', 'tugen': 'Itilil nea', 'english': 'You are beautiful', 'swahili': 'Wewe ni mzuri', 'pronunciation': 'ee-tee-LEEL neh-AH', 'difficulty': 2},
  {'id': 'em012', 'category_id': 'emotions', 'tugen': 'Chaman nenyun', 'english': 'My love', 'swahili': 'Upendo wangu', 'pronunciation': 'CHAH-man neh-NYOON', 'difficulty': 2},
];

/// Vocabulary deck seed data
const decks = [
  // Existing decks
  {'id': 'basic_greetings', 'name_en': 'Basic Greetings', 'name_sw': 'Salamu za Msingi', 'name_tug': 'Chamgeinik', 'description': 'Essential greetings and polite expressions', 'icon': '\u{1F44B}', 'total_cards': 11, 'is_premium': false},
  {'id': 'numbers_1_10', 'name_en': 'Numbers 1–10', 'name_sw': 'Nambari 1–10', 'name_tug': 'Sigindeek 1–10', 'description': 'Count from one to ten in Tugen', 'icon': '\u{1F522}', 'total_cards': 10, 'is_premium': false},
  {'id': 'family_members', 'name_en': 'Family Members', 'name_sw': 'Wanafamilia', 'name_tug': 'Kapchi', 'description': 'Learn family relationship terms', 'icon': '\u{1F46A}', 'total_cards': 6, 'is_premium': false},
  {'id': 'food_drink', 'name_en': 'Food & Drink', 'name_sw': 'Chakula na Vinywaji', 'name_tug': 'Amak ak Beet', 'description': 'Common food and drink vocabulary', 'icon': '\u{1F35E}', 'total_cards': 5, 'is_premium': false},
  // New decks
  {'id': 'numbers_11_20', 'name_en': 'Numbers 11–20', 'name_sw': 'Nambari 11–20', 'name_tug': 'Sigindeek 11–20', 'description': 'Count from eleven to twenty in Tugen', 'icon': '\u{1F522}', 'total_cards': 10, 'is_premium': false},
  {'id': 'animals_nature', 'name_en': 'Animals & Nature', 'name_sw': 'Wanyama na Mazingira', 'name_tug': 'Tisiik ak Emet', 'description': 'Wildlife, livestock, and natural world vocabulary', 'icon': '\u{1F98A}', 'total_cards': 22, 'is_premium': false},
  {'id': 'body_parts', 'name_en': 'Body Parts', 'name_sw': 'Sehemu za Mwili', 'name_tug': 'Chesik', 'description': 'Head to toe vocabulary', 'icon': '\u{1F464}', 'total_cards': 14, 'is_premium': false},
  {'id': 'time_calendar', 'name_en': 'Time & Calendar', 'name_sw': 'Wakati na Kalenda', 'name_tug': 'Betusiek', 'description': 'Days of the week, time of day, and time expressions', 'icon': '\u{1F4C5}', 'total_cards': 15, 'is_premium': false},
  {'id': 'emotions_love', 'name_en': 'Emotions & Love', 'name_sw': 'Hisia na Upendo', 'name_tug': 'Chamyet', 'description': 'Expressing feelings and affection in Tugen', 'icon': '\u{1F970}', 'total_cards': 12, 'is_premium': false},
];

/// Vocab cards — mirror the phrases for flashcard practice
const vocabCards = [
  // ── Basic Greetings deck ──────────────────────────────────────────────────
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

  // ── Numbers 1–10 deck ─────────────────────────────────────────────────────
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

  // ── Family Members deck ───────────────────────────────────────────────────
  {'id': 'vc_f001', 'deck_id': 'family_members', 'tugen': 'Papa', 'english': 'Father', 'swahili': 'Baba', 'difficulty': 1},
  {'id': 'vc_f002', 'deck_id': 'family_members', 'tugen': 'Mama', 'english': 'Mother', 'swahili': 'Mama', 'difficulty': 1},
  {'id': 'vc_f003', 'deck_id': 'family_members', 'tugen': 'Lakwa', 'english': 'Child', 'swahili': 'Mtoto', 'difficulty': 1},
  {'id': 'vc_f004', 'deck_id': 'family_members', 'tugen': 'Lagok', 'english': 'Children', 'swahili': 'Watoto', 'difficulty': 1},
  {'id': 'vc_f005', 'deck_id': 'family_members', 'tugen': 'Kogo', 'english': 'Grandmother', 'swahili': 'Bibi', 'difficulty': 1},
  {'id': 'vc_f006', 'deck_id': 'family_members', 'tugen': 'Kugo', 'english': 'Grandfather', 'swahili': 'Babu', 'difficulty': 1},

  // ── Food & Drink deck ─────────────────────────────────────────────────────
  {'id': 'vc_fd001', 'deck_id': 'food_drink', 'tugen': 'Mursik', 'english': 'Fermented milk', 'swahili': 'Maziwa lala', 'difficulty': 1},
  {'id': 'vc_fd002', 'deck_id': 'food_drink', 'tugen': 'Kimyet', 'english': 'Food / Meal', 'swahili': 'Chakula', 'difficulty': 1},
  {'id': 'vc_fd003', 'deck_id': 'food_drink', 'tugen': 'Beet', 'english': 'Water', 'swahili': 'Maji', 'difficulty': 1},
  {'id': 'vc_fd004', 'deck_id': 'food_drink', 'tugen': 'Kimnyet', 'english': 'Ugali', 'swahili': 'Ugali', 'difficulty': 1},
  {'id': 'vc_fd005', 'deck_id': 'food_drink', 'tugen': 'Chegoek', 'english': 'Vegetables', 'swahili': 'Mboga', 'difficulty': 1},

  // ── Numbers 11–20 deck ────────────────────────────────────────────────────
  {'id': 'vc_n011', 'deck_id': 'numbers_11_20', 'tugen': 'Taman agenge', 'english': 'Eleven', 'swahili': 'Kumi na moja', 'difficulty': 2},
  {'id': 'vc_n012', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak aeng\'', 'english': 'Twelve', 'swahili': 'Kumi na mbili', 'difficulty': 2},
  {'id': 'vc_n013', 'deck_id': 'numbers_11_20', 'tugen': 'Sosom', 'english': 'Thirteen', 'swahili': 'Kumi na tatu', 'difficulty': 2},
  {'id': 'vc_n014', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak angwan', 'english': 'Fourteen', 'swahili': 'Kumi na nne', 'difficulty': 2},
  {'id': 'vc_n015', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak muut', 'english': 'Fifteen', 'swahili': 'Kumi na tano', 'difficulty': 2},
  {'id': 'vc_n016', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak lo', 'english': 'Sixteen', 'swahili': 'Kumi na sita', 'difficulty': 2},
  {'id': 'vc_n017', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak tisap', 'english': 'Seventeen', 'swahili': 'Kumi na saba', 'difficulty': 2},
  {'id': 'vc_n018', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak sisit', 'english': 'Eighteen', 'swahili': 'Kumi na nane', 'difficulty': 2},
  {'id': 'vc_n019', 'deck_id': 'numbers_11_20', 'tugen': 'Taman ak sogol', 'english': 'Nineteen', 'swahili': 'Kumi na tisa', 'difficulty': 2},
  {'id': 'vc_n020', 'deck_id': 'numbers_11_20', 'tugen': 'Tuptem', 'english': 'Twenty', 'swahili': 'Ishirini', 'difficulty': 2},

  // ── Animals & Nature deck ─────────────────────────────────────────────────
  {'id': 'vc_a001', 'deck_id': 'animals_nature', 'tugen': 'Ng\'etundo', 'english': 'Lion', 'swahili': 'Simba', 'difficulty': 1},
  {'id': 'vc_a002', 'deck_id': 'animals_nature', 'tugen': 'Cheplanget', 'english': 'Leopard', 'swahili': 'Chui', 'difficulty': 2},
  {'id': 'vc_a003', 'deck_id': 'animals_nature', 'tugen': 'Beliot', 'english': 'Elephant', 'swahili': 'Tembo', 'difficulty': 1},
  {'id': 'vc_a004', 'deck_id': 'animals_nature', 'tugen': 'Soet', 'english': 'Buffalo', 'swahili': 'Nyati', 'difficulty': 1},
  {'id': 'vc_a005', 'deck_id': 'animals_nature', 'tugen': 'Leitigo', 'english': 'Zebra', 'swahili': 'Punda milia', 'difficulty': 2},
  {'id': 'vc_a006', 'deck_id': 'animals_nature', 'tugen': 'Kimagetiet', 'english': 'Hyena', 'swahili': 'Fisi', 'difficulty': 2},
  {'id': 'vc_a007', 'deck_id': 'animals_nature', 'tugen': 'Moset', 'english': 'Monkey', 'swahili': 'Tumbili', 'difficulty': 2},
  {'id': 'vc_a008', 'deck_id': 'animals_nature', 'tugen': 'Cherekweny', 'english': 'Hare', 'swahili': 'Sungura', 'difficulty': 2},
  {'id': 'vc_a009', 'deck_id': 'animals_nature', 'tugen': 'Munywet', 'english': 'Snake', 'swahili': 'Nyoka', 'difficulty': 1},
  {'id': 'vc_a010', 'deck_id': 'animals_nature', 'tugen': 'Boinet', 'english': 'Gazelle', 'swahili': 'Swala', 'difficulty': 2},
  {'id': 'vc_a011', 'deck_id': 'animals_nature', 'tugen': 'Teta', 'english': 'Cow', 'swahili': 'Ng\'ombe', 'difficulty': 1},
  {'id': 'vc_a012', 'deck_id': 'animals_nature', 'tugen': 'Artet', 'english': 'Goat', 'swahili': 'Mbuzi', 'difficulty': 1},
  {'id': 'vc_a013', 'deck_id': 'animals_nature', 'tugen': 'Ngechiryet', 'english': 'Sheep', 'swahili': 'Kondoo', 'difficulty': 2},
  {'id': 'vc_a014', 'deck_id': 'animals_nature', 'tugen': 'Ingokyet', 'english': 'Chicken', 'swahili': 'Kuku', 'difficulty': 1},
  {'id': 'vc_a015', 'deck_id': 'animals_nature', 'tugen': 'Kiptawirit', 'english': 'Dog', 'swahili': 'Mbwa', 'difficulty': 2},
  {'id': 'vc_a016', 'deck_id': 'animals_nature', 'tugen': 'Pakeet', 'english': 'Cat', 'swahili': 'Paka', 'difficulty': 1},
  {'id': 'vc_a017', 'deck_id': 'animals_nature', 'tugen': 'Taratiet', 'english': 'Bird', 'swahili': 'Ndege', 'difficulty': 1},
  {'id': 'vc_a018', 'deck_id': 'animals_nature', 'tugen': 'Asista', 'english': 'Sun', 'swahili': 'Jua', 'difficulty': 1},
  {'id': 'vc_a019', 'deck_id': 'animals_nature', 'tugen': 'Arawet', 'english': 'Moon', 'swahili': 'Mwezi', 'difficulty': 1},
  {'id': 'vc_a020', 'deck_id': 'animals_nature', 'tugen': 'Ropta', 'english': 'Rain', 'swahili': 'Mvua', 'difficulty': 1},
  {'id': 'vc_a021', 'deck_id': 'animals_nature', 'tugen': 'Keet', 'english': 'Tree', 'swahili': 'Mti', 'difficulty': 1},
  {'id': 'vc_a022', 'deck_id': 'animals_nature', 'tugen': 'Kipsengwet', 'english': 'Sky / Heaven', 'swahili': 'Anga / Mbinguni', 'difficulty': 2},

  // ── Body Parts deck ───────────────────────────────────────────────────────
  {'id': 'vc_b001', 'deck_id': 'body_parts', 'tugen': 'Metit', 'english': 'Head', 'swahili': 'Kichwa', 'difficulty': 1},
  {'id': 'vc_b002', 'deck_id': 'body_parts', 'tugen': 'Togoch', 'english': 'Face', 'swahili': 'Uso', 'difficulty': 1},
  {'id': 'vc_b003', 'deck_id': 'body_parts', 'tugen': 'Iitit', 'english': 'Ear', 'swahili': 'Sikio', 'difficulty': 1},
  {'id': 'vc_b004', 'deck_id': 'body_parts', 'tugen': 'Konda', 'english': 'Eye', 'swahili': 'Jicho', 'difficulty': 1},
  {'id': 'vc_b005', 'deck_id': 'body_parts', 'tugen': 'Seruu', 'english': 'Nose', 'swahili': 'Pua', 'difficulty': 1},
  {'id': 'vc_b006', 'deck_id': 'body_parts', 'tugen': 'Kutit', 'english': 'Mouth', 'swahili': 'Mdomo', 'difficulty': 1},
  {'id': 'vc_b007', 'deck_id': 'body_parts', 'tugen': 'Eut', 'english': 'Arm / Hand', 'swahili': 'Mkono', 'difficulty': 1},
  {'id': 'vc_b008', 'deck_id': 'body_parts', 'tugen': 'Keldo', 'english': 'Leg', 'swahili': 'Mguu', 'difficulty': 1},
  {'id': 'vc_b009', 'deck_id': 'body_parts', 'tugen': 'Moet', 'english': 'Stomach', 'swahili': 'Tumbo', 'difficulty': 1},
  {'id': 'vc_b010', 'deck_id': 'body_parts', 'tugen': 'Siiyet', 'english': 'Finger', 'swahili': 'Kidole', 'difficulty': 2},
  {'id': 'vc_b011', 'deck_id': 'body_parts', 'tugen': 'Sumek', 'english': 'Hair', 'swahili': 'Nywele', 'difficulty': 1},
  {'id': 'vc_b012', 'deck_id': 'body_parts', 'tugen': 'Patai', 'english': 'Back', 'swahili': 'Mgongo', 'difficulty': 2},
  {'id': 'vc_b013', 'deck_id': 'body_parts', 'tugen': 'Keldeit', 'english': 'Tooth', 'swahili': 'Jino', 'difficulty': 2},
  {'id': 'vc_b014', 'deck_id': 'body_parts', 'tugen': 'Ngelyepta', 'english': 'Tongue', 'swahili': 'Ulimi', 'difficulty': 2},

  // ── Time & Calendar deck ──────────────────────────────────────────────────
  {'id': 'vc_tm001', 'deck_id': 'time_calendar', 'tugen': 'Kotisap', 'english': 'Sunday', 'swahili': 'Jumapili', 'difficulty': 2},
  {'id': 'vc_tm002', 'deck_id': 'time_calendar', 'tugen': 'Kotaai', 'english': 'Monday', 'swahili': 'Jumatatu', 'difficulty': 2},
  {'id': 'vc_tm003', 'deck_id': 'time_calendar', 'tugen': 'Koaeng\'', 'english': 'Tuesday', 'swahili': 'Jumanne', 'difficulty': 2},
  {'id': 'vc_tm004', 'deck_id': 'time_calendar', 'tugen': 'Kosomok', 'english': 'Wednesday', 'swahili': 'Jumatano', 'difficulty': 2},
  {'id': 'vc_tm005', 'deck_id': 'time_calendar', 'tugen': 'Koang\'wan', 'english': 'Thursday', 'swahili': 'Alhamisi', 'difficulty': 2},
  {'id': 'vc_tm006', 'deck_id': 'time_calendar', 'tugen': 'Komuut', 'english': 'Friday', 'swahili': 'Ijumaa', 'difficulty': 2},
  {'id': 'vc_tm007', 'deck_id': 'time_calendar', 'tugen': 'Kolo', 'english': 'Saturday', 'swahili': 'Jumamosi', 'difficulty': 2},
  {'id': 'vc_tm008', 'deck_id': 'time_calendar', 'tugen': 'Rani', 'english': 'Today', 'swahili': 'Leo', 'difficulty': 1},
  {'id': 'vc_tm009', 'deck_id': 'time_calendar', 'tugen': 'Mutai', 'english': 'Tomorrow', 'swahili': 'Kesho', 'difficulty': 1},
  {'id': 'vc_tm010', 'deck_id': 'time_calendar', 'tugen': 'Betut', 'english': 'Day', 'swahili': 'Siku', 'difficulty': 1},
  {'id': 'vc_tm011', 'deck_id': 'time_calendar', 'tugen': 'Karon', 'english': 'Morning', 'swahili': 'Asubuhi', 'difficulty': 1},
  {'id': 'vc_tm012', 'deck_id': 'time_calendar', 'tugen': 'Bet', 'english': 'Afternoon / Midday', 'swahili': 'Mchana', 'difficulty': 1},
  {'id': 'vc_tm013', 'deck_id': 'time_calendar', 'tugen': 'Koskoliny', 'english': 'Evening', 'swahili': 'Jioni', 'difficulty': 1},
  {'id': 'vc_tm014', 'deck_id': 'time_calendar', 'tugen': 'Runet', 'english': 'Night', 'swahili': 'Usiku', 'difficulty': 1},
  {'id': 'vc_tm015', 'deck_id': 'time_calendar', 'tugen': 'Kenyit', 'english': 'Year', 'swahili': 'Mwaka', 'difficulty': 2},

  // ── Emotions & Love deck ──────────────────────────────────────────────────
  {'id': 'vc_em001', 'deck_id': 'emotions_love', 'tugen': 'Achamin', 'english': 'I love you', 'swahili': 'Nakupenda', 'difficulty': 1},
  {'id': 'vc_em002', 'deck_id': 'emotions_love', 'tugen': 'Achamin maan', 'english': 'I love you so much', 'swahili': 'Nakupenda sana', 'difficulty': 1},
  {'id': 'vc_em003', 'deck_id': 'emotions_love', 'tugen': 'Kia kosanin', 'english': 'I miss you', 'swahili': 'Nakukumbuka', 'difficulty': 2},
  {'id': 'vc_em004', 'deck_id': 'emotions_love', 'tugen': 'Chamyet', 'english': 'Love', 'swahili': 'Upendo', 'difficulty': 1},
  {'id': 'vc_em005', 'deck_id': 'emotions_love', 'tugen': 'Poiboiyet', 'english': 'Joy', 'swahili': 'Furaha', 'difficulty': 2},
  {'id': 'vc_em006', 'deck_id': 'emotions_love', 'tugen': 'Kaalyeet', 'english': 'Peace', 'swahili': 'Amani', 'difficulty': 2},
  {'id': 'vc_em007', 'deck_id': 'emotions_love', 'tugen': 'Muitaet', 'english': 'Patience', 'swahili': 'Uvumilivu', 'difficulty': 3},
  {'id': 'vc_em008', 'deck_id': 'emotions_love', 'tugen': 'Talasyet', 'english': 'Kindness', 'swahili': 'Wema', 'difficulty': 3},
  {'id': 'vc_em009', 'deck_id': 'emotions_love', 'tugen': 'Kanget', 'english': 'I am tired', 'swahili': 'Nimechoka', 'difficulty': 2},
  {'id': 'vc_em010', 'deck_id': 'emotions_love', 'tugen': 'Mutyoo', 'english': 'I am sorry', 'swahili': 'Samahani', 'difficulty': 1},
  {'id': 'vc_em011', 'deck_id': 'emotions_love', 'tugen': 'Itilil nea', 'english': 'You are beautiful', 'swahili': 'Wewe ni mzuri', 'difficulty': 2},
  {'id': 'vc_em012', 'deck_id': 'emotions_love', 'tugen': 'Chaman nenyun', 'english': 'My love', 'swahili': 'Upendo wangu', 'difficulty': 2},
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
  print('Categories:     ${categories.length}');
  print('Phrases:        ${phrases.length}');
  print('Decks:          ${decks.length}');
  print('Vocab Cards:    ${vocabCards.length}');
  print('Stories:        ${stories.length}');
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
  print('  await supabase.from("decks").upsert(decks);');
  print('  await supabase.from("vocab_cards").upsert(vocabCards);');
  print('  await supabase.from("stories").upsert(stories);');
  print('  await supabase.from("story_segments").upsert(storySegments);');
}
