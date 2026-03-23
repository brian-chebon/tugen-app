# Tugen Language Learning App

Learn the Tugen (Kalenjin) language through interactive phrases, vocabulary games, and cultural stories.

## Features

- **Phrasebook**: Browse categorized phrases with native audio, Swahili & English translations
- **Vocabulary Game**: Flashcards with FSRS spaced repetition, multiple-choice quizzes, gamification (XP, streaks, hearts, leaderboards)
- **Interactive Stories**: Audio stories with synchronized transcripts, comprehension exercises
- **Offline-First**: Full offline support with background sync
- **Trilingual**: UI in English, Swahili, and Tugen

## Architecture

```
Feature-first Clean Architecture + Riverpod
├── core/         (audio, auth, database, network, supabase, sync, router, l10n, theme)
├── features/     (phrasebook, vocab_game, stories, user_progress, settings)
└── shared/       (models, widgets, extensions)
```

**Key decisions:**
- **State Management**: Riverpod (compile-safe, async-native)
- **Local DB**: Drift (type-safe SQL, reactive streams, migrations)
- **Auth**: Firebase Auth (email/password, anonymous, account linking)
- **Database**: Supabase (PostgreSQL with Row Level Security)
- **File Storage**: Firebase Storage (audio, images)
- **Analytics**: Firebase Analytics
- **Audio**: just_audio (gapless, clip playback, speed control)
- **Spaced Repetition**: FSRS v4 via `fsrs` package (20-30% fewer reviews than SM-2)
- **Background Sync**: workmanager + transactional outbox pattern

## Setup

### Prerequisites
- Flutter SDK >= 3.24.0
- Dart >= 3.5.0
- Firebase CLI (`npm install -g firebase-tools`)
- A Supabase project (https://supabase.com)
- Android Studio / Xcode

### Steps

1. **Clone and install dependencies**
   ```bash
   git clone <repo-url>
   cd tugen_app
   flutter pub get
   ```

2. **Configure Firebase (Auth, Storage, Analytics)**
   ```bash
   # Login to Firebase
   firebase login

   # Configure for your project
   flutterfire configure

   # This auto-generates lib/firebase_options.dart
   ```

3. **Configure Supabase (Database)**
   ```bash
   # Copy the env example and fill in your Supabase credentials
   cp .env.example .env

   # Run the schema SQL in Supabase SQL Editor
   # See supabase/schema.sql
   ```

4. **Generate Drift database code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Seed Supabase with initial content**
   ```bash
   # Option A: Run seed SQL directly in Supabase SQL Editor
   # Option B: Use the Supabase Dashboard Table Editor
   # Option C: Use supabase-js with service role key
   dart run scripts/seed_supabase.dart  # prints instructions
   ```

6. **Run the app**
   ```bash
   # Pass Supabase credentials via dart-define
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

### Firebase Setup Checklist
- [ ] Create Firebase project at https://console.firebase.google.com
- [ ] Enable Authentication (Email/Password + Anonymous)
- [ ] Create Storage bucket for audio files
- [ ] Enable Analytics
- [ ] Run `flutterfire configure` and replace firebase_options.dart

### Supabase Setup Checklist
- [ ] Create Supabase project at https://supabase.com
- [ ] Run `supabase/schema.sql` in the SQL Editor to create tables and RLS policies
- [ ] Seed initial content (categories, phrases, decks, vocab cards, stories)
- [ ] Copy Project URL and anon key to `.env` / `--dart-define` flags

## Code Generation

After modifying Drift tables, Freezed models, or Riverpod providers:
```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
dart run build_runner watch --delete-conflicting-outputs
```

## Audio Content

Place audio files in Firebase Storage under:
```
audio/
  phrases/
    g001.aac   # Phrase audio (AAC 64-96kbps)
    g002.aac
    ...
  stories/
    story_001.aac   # Full story audio (AAC 128kbps)
    story_002.aac
```

Recommended format: **AAC at 64-96 kbps** for phrases, **128 kbps** for stories.
Record with Audacity or smartphone in a quiet environment.

## Project Structure

```
lib/
├── main.dart                    # Entry point (Firebase + Supabase init)
├── app.dart                     # MaterialApp with routing & theming
├── firebase_options.dart        # Auto-generated Firebase config
├── core/
│   ├── audio/audio_service.dart       # just_audio wrapper with caching
│   ├── auth/auth_provider.dart        # Firebase Auth + Riverpod
│   ├── auth/login_screen.dart         # Login/signup UI
│   ├── constants/app_constants.dart   # App-wide constants
│   ├── database/
│   │   ├── app_database.dart          # Drift DB definition (all tables)
│   │   ├── database_provider.dart     # Riverpod provider
│   │   └── daos/
│   │       ├── phrases_dao.dart       # Phrase queries
│   │       ├── vocab_dao.dart         # Vocab card queries
│   │       ├── stories_dao.dart       # Story queries
│   │       └── progress_dao.dart      # User progress & stats
│   ├── l10n/app_localizations.dart    # EN/SW/TUG translations
│   ├── network/network_service.dart   # Dio HTTP client
│   ├── router/
│   │   ├── app_router.dart            # go_router with shell routes
│   │   └── shell_scaffold.dart        # Bottom nav shell
│   ├── supabase/
│   │   └── supabase_provider.dart     # Supabase client provider
│   ├── sync/
│   │   ├── sync_service.dart          # Offline sync engine (Supabase)
│   │   └── sync_worker.dart           # Background worker
│   └── theme/app_theme.dart           # Material 3 theme
├── features/
│   ├── phrasebook/
│   │   └── presentation/
│   │       ├── providers/phrasebook_providers.dart
│   │       ├── screens/
│   │       │   ├── phrasebook_screen.dart   # Categories grid + search
│   │       │   ├── category_screen.dart     # Phrase list
│   │       │   └── phrase_detail_screen.dart # Audio + translations
│   │       └── widgets/category_card.dart
│   ├── vocab_game/
│   │   ├── domain/usecases/review_service.dart  # FSRS scheduling
│   │   └── presentation/
│   │       ├── providers/vocab_providers.dart
│   │       └── screens/
│   │           ├── vocab_home_screen.dart   # Decks + stats bar
│   │           ├── flashcard_screen.dart    # FSRS flashcards
│   │           └── quiz_screen.dart         # MCQ quiz + confetti
│   ├── stories/
│   │   └── presentation/
│   │       ├── providers/stories_providers.dart
│   │       └── screens/
│   │           ├── stories_screen.dart      # Story list + filters
│   │           └── story_player_screen.dart # Audio + synced transcript
│   ├── user_progress/
│   │   └── presentation/screens/profile_screen.dart
│   └── settings/
│       └── presentation/
│           ├── providers/locale_provider.dart
│           └── screens/settings_screen.dart
├── shared/
│   ├── extensions/context_extensions.dart
│   └── widgets/common_widgets.dart
└── scripts/
    └── seed_supabase.dart   # Content seeder script
```

## License

MIT — Built for the Tugen community.
