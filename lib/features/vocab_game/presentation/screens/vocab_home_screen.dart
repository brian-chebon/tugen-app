import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/vocab_providers.dart';

class VocabHomeScreen extends ConsumerWidget {
  const VocabHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final decks = ref.watch(decksProvider);
    final dueCount = ref.watch(dueCountProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.vocabGame)),
      body: CustomScrollView(
        slivers: [
          // Stats header
          SliverToBoxAdapter(
            child: stats.when(
              data: (s) => _StatsBar(stats: s, theme: theme),
              loading: () => const SizedBox(height: 100),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Due cards banner
          SliverToBoxAdapter(
            child: dueCount.when(
              data: (count) => count > 0
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: AppColors.accent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$count ${l10n.cardsDueForReview}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          FilledButton(
                            onPressed: () =>
                                context.go('/vocab/flashcards/due'),
                            child: Text(l10n.review),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.vocabularyDecks,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // Deck list
          decks.when(
            data: (deckList) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final deck = deckList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Text(deck.icon,
                          style: const TextStyle(fontSize: 32)),
                      title: Text(
                        deck.nameEn,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${deck.totalCards} ${l10n.cardsLabel} \u2022 ${deck.nameTug}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'flashcards') {
                            context.go('/vocab/flashcards/${deck.id}');
                          } else if (v == 'quiz') {
                            context.go('/vocab/quiz/${deck.id}');
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'flashcards',
                            child: Row(
                              children: [
                                const Icon(Icons.style),
                                const SizedBox(width: 8),
                                Text(l10n.flashcards),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'quiz',
                            child: Row(
                              children: [
                                const Icon(Icons.quiz),
                                const SizedBox(width: 8),
                                Text(l10n.quiz),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: deckList.length,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final dynamic stats;
  final ThemeData theme;

  const _StatsBar({required this.stats, required this.theme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.local_fire_department,
            value: '${stats.currentStreak}',
            label: l10n.streak,
            color: Colors.orange,
          ),
          _StatItem(
            icon: Icons.star,
            value: '${stats.totalXp}',
            label: l10n.xp,
            color: Colors.amber,
          ),
          _StatItem(
            icon: Icons.school,
            value: '${stats.wordsLearned}',
            label: l10n.wordsLearned,
            color: Colors.lightGreenAccent,
          ),
          _StatItem(
            icon: Icons.favorite,
            value: '${stats.hearts}',
            label: l10n.hearts,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
