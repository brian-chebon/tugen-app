import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/phrasebook/presentation/screens/phrasebook_screen.dart';
import '../../features/phrasebook/presentation/screens/phrase_detail_screen.dart';
import '../../features/vocab_game/presentation/screens/vocab_home_screen.dart';
import '../../features/vocab_game/presentation/screens/quiz_screen.dart';
import '../../features/vocab_game/presentation/screens/flashcard_screen.dart';
import '../../features/stories/presentation/screens/stories_screen.dart';
import '../../features/stories/presentation/screens/story_player_screen.dart';
import '../../features/user_progress/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../core/auth/auth_provider.dart';
import '../../features/phrasebook/presentation/screens/category_screen.dart';
import '../auth/login_screen.dart';
import 'shell_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/phrasebook',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isOnLogin = state.matchedLocation == '/login';

      // Allow unauthenticated access to main features
      // Only redirect to login for profile/settings
      if (!isLoggedIn && state.matchedLocation.startsWith('/profile')) {
        return '/login?redirect=${state.matchedLocation}';
      }
      if (isLoggedIn && isOnLogin) {
        return state.uri.queryParameters['redirect'] ?? '/phrasebook';
      }
      return null;
    },
    routes: [
      // Login
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),

      // Main shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Phrasebook tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: '/phrasebook',
                builder: (context, state) => const PhrasebookScreen(),
                routes: [
                  GoRoute(
                    path: 'category/:categoryId',
                    builder: (context, state) => CategoryScreen(
                      categoryId: state.pathParameters['categoryId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'phrase/:phraseId',
                    builder: (context, state) => PhraseDetailScreen(
                      phraseId: state.pathParameters['phraseId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Vocab Game tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vocab',
                builder: (context, state) => const VocabHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'quiz/:deckId',
                    builder: (context, state) => QuizScreen(
                      deckId: state.pathParameters['deckId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'flashcards/:deckId',
                    builder: (context, state) => FlashcardScreen(
                      deckId: state.pathParameters['deckId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Stories tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stories',
                builder: (context, state) => const StoriesScreen(),
                routes: [
                  GoRoute(
                    path: 'play/:storyId',
                    builder: (context, state) => StoryPlayerScreen(
                      storyId: state.pathParameters['storyId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Profile tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
