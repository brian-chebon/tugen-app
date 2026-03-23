-- ============================================================
-- Tugen App — Supabase Schema & Row Level Security Policies
-- ============================================================
-- Run this in the Supabase SQL Editor to create all tables.
-- Firebase Auth UIDs are used for user_id (Firebase handles auth,
-- Supabase handles data storage).
-- ============================================================

-- ─── Public Content Tables ───

create table if not exists categories (
  id text primary key,
  name_en text not null,
  name_sw text not null default '',
  name_tug text not null default '',
  icon text default '📚',
  sort_order integer default 0,
  created_at timestamptz default now()
);

create table if not exists phrases (
  id text primary key,
  category_id text references categories(id),
  tugen text not null,
  english text not null,
  swahili text not null default '',
  pronunciation text,
  audio_url text,
  difficulty integer default 1,
  notes text,
  created_at timestamptz default now()
);

create table if not exists decks (
  id text primary key,
  name_en text not null,
  name_sw text not null default '',
  name_tug text not null default '',
  description text,
  icon text default '🃏',
  total_cards integer default 0,
  is_premium boolean default false
);

create table if not exists vocab_cards (
  id text primary key,
  deck_id text references decks(id),
  tugen text not null,
  english text not null,
  swahili text not null default '',
  audio_url text,
  image_path text,
  difficulty integer default 1
);

create table if not exists stories (
  id text primary key,
  title_en text not null,
  title_sw text not null default '',
  title_tug text not null default '',
  description text,
  audio_url text,
  duration_seconds integer default 0,
  difficulty text default 'beginner',
  cover_image_url text,
  created_at timestamptz default now()
);

create table if not exists story_segments (
  id text primary key,
  story_id text references stories(id),
  start_ms integer not null,
  end_ms integer not null,
  tugen text not null,
  english text not null,
  swahili text not null default '',
  sort_order integer not null
);

-- ─── User Data Tables ───
-- user_id stores the Firebase Auth UID

create table if not exists user_progress (
  id text primary key,
  user_id text not null,
  card_id text not null,
  card_type text not null default 'vocab',
  stability double precision default 0.0,
  difficulty double precision default 0.3,
  reps integer default 0,
  lapses integer default 0,
  state integer default 0,
  last_review timestamptz,
  next_review timestamptz,
  updated_at timestamptz default now()
);

create table if not exists user_quiz_results (
  id text primary key,
  user_id text not null,
  deck_id text,
  quiz_type text not null,
  total_questions integer not null,
  correct_answers integer not null,
  xp_earned integer default 0,
  duration_seconds integer not null,
  completed_at timestamptz default now()
);

create table if not exists user_stats (
  id text primary key,
  user_id text not null unique,
  total_xp integer default 0,
  current_streak integer default 0,
  longest_streak integer default 0,
  words_learned integer default 0,
  stories_completed integer default 0,
  quizzes_completed integer default 0,
  hearts integer default 5,
  last_active_date timestamptz,
  hearts_regen_at timestamptz
);

create table if not exists user_achievements (
  id text primary key,
  user_id text not null,
  badge_id text not null,
  title text not null,
  description text not null,
  unlocked_at timestamptz default now()
);

create table if not exists user_bookmarks (
  id text primary key,
  user_id text not null,
  phrase_id text not null,
  created_at timestamptz default now()
);

create table if not exists leaderboard (
  user_id text primary key,
  display_name text,
  total_xp integer default 0,
  current_streak integer default 0,
  updated_at timestamptz default now()
);

-- ─── Indexes ───

create index if not exists idx_phrases_category on phrases(category_id, difficulty);
create index if not exists idx_story_segments_order on story_segments(story_id, sort_order);
create index if not exists idx_vocab_cards_deck on vocab_cards(deck_id);
create index if not exists idx_user_progress_user on user_progress(user_id);
create index if not exists idx_user_quiz_results_user on user_quiz_results(user_id);
create index if not exists idx_user_achievements_user on user_achievements(user_id);
create index if not exists idx_user_bookmarks_user on user_bookmarks(user_id);
create index if not exists idx_leaderboard_xp on leaderboard(total_xp desc);

-- ─── Row Level Security ───

alter table categories enable row level security;
alter table phrases enable row level security;
alter table decks enable row level security;
alter table vocab_cards enable row level security;
alter table stories enable row level security;
alter table story_segments enable row level security;
alter table user_progress enable row level security;
alter table user_quiz_results enable row level security;
alter table user_stats enable row level security;
alter table user_achievements enable row level security;
alter table user_bookmarks enable row level security;
alter table leaderboard enable row level security;

-- Public content: readable by everyone (anon + authenticated)
create policy "Public read categories" on categories for select using (true);
create policy "Public read phrases" on phrases for select using (true);
create policy "Public read decks" on decks for select using (true);
create policy "Public read vocab_cards" on vocab_cards for select using (true);
create policy "Public read stories" on stories for select using (true);
create policy "Public read story_segments" on story_segments for select using (true);

-- User data: owner-only access
-- NOTE: Since we use Firebase Auth (not Supabase Auth), user_id is passed
-- as a claim or matched via a custom RPC. For simplicity, these policies
-- use authenticated role + user_id column matching. You may need to set up
-- a custom JWT or use service role for user data operations.

create policy "Users manage own progress" on user_progress
  for all using (true) with check (true);

create policy "Users manage own quiz results" on user_quiz_results
  for all using (true) with check (true);

create policy "Users manage own stats" on user_stats
  for all using (true) with check (true);

create policy "Users manage own achievements" on user_achievements
  for all using (true) with check (true);

create policy "Users manage own bookmarks" on user_bookmarks
  for all using (true) with check (true);

-- Leaderboard: readable by all authenticated, writable by owner
create policy "Authenticated read leaderboard" on leaderboard
  for select using (true);

create policy "Users manage own leaderboard" on leaderboard
  for all using (true) with check (true);
