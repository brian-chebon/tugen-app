import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/database/daos/progress_dao.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../vocab_game/presentation/providers/vocab_providers.dart';

/// Watch achievements
final achievementsProvider = StreamProvider((ref) {
  final dao = ProgressDao(ref.watch(databaseProvider));
  return dao.watchAchievements();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final stats = ref.watch(userStatsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/profile/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + Name
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                (user?.displayName ?? 'G')[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 32,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.displayName ?? l10n.guestLearner,
              style: theme.textTheme.titleLarge,
            ),
            if (user?.email != null)
              Text(
                user!.email!,
                style: theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: 24),

            // Stats grid
            stats.when(
              data: (s) => Column(
                children: [
                  Row(
                    children: [
                      _StatTile(
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orange,
                        value: '${s.currentStreak}',
                        label: l10n.streak,
                      ),
                      const SizedBox(width: 12),
                      _StatTile(
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        value: '${s.totalXp}',
                        label: l10n.totalXp,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatTile(
                        icon: Icons.school,
                        iconColor: Colors.green,
                        value: '${s.wordsLearned}',
                        label: l10n.wordsLearned,
                      ),
                      const SizedBox(width: 12),
                      _StatTile(
                        icon: Icons.auto_stories,
                        iconColor: Colors.blue,
                        value: '${s.storiesCompleted}',
                        label: l10n.stories,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatTile(
                        icon: Icons.emoji_events,
                        iconColor: Colors.purple,
                        value: '${s.longestStreak}',
                        label: l10n.longestStreak,
                      ),
                      const SizedBox(width: 12),
                      _StatTile(
                        icon: Icons.quiz,
                        iconColor: Colors.teal,
                        value: '${s.quizzesCompleted}',
                        label: l10n.quizzes,
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),

            const SizedBox(height: 24),

            // Achievements section
            achievementsAsync.when(
              data: (badges) {
                if (badges.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        l10n.translate('achievements'),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: badges.map((badge) {
                        return Chip(
                          avatar: const Icon(Icons.military_tech,
                              size: 18, color: Colors.amber),
                          label: Text(badge.title),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // Sign in prompt for guests
            if (user?.isAnonymous == true)
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        l10n.saveProgress,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.go('/login'),
                        child: Text(l10n.createAccount),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
