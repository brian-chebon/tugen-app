import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
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
                              '$count cards due for review',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          FilledButton(
                            onPressed: () =>
                                context.go('/vocab/flashcards/due'),
                            child: const Text('Review'),
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Vocabulary Decks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Text(deck.icon, style: const TextStyle(fontSize: 32)),
                      title: Text(
                        deck.nameEn,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${deck.totalCards} cards • ${deck.nameTug}',
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
                          const PopupMenuItem(
                            value: 'flashcards',
                            child: Row(
                              children: [
                                Icon(Icons.style),
                                SizedBox(width: 8),
                                Text('Flashcards'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'quiz',
                            child: Row(
                              children: [
                                Icon(Icons.quiz),
                                SizedBox(width: 8),
                                Text('Quiz'),
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
            label: 'Streak',
            color: Colors.orange,
          ),
          _StatItem(
            icon: Icons.star,
            value: '${stats.totalXp}',
            label: 'XP',
            color: Colors.amber,
          ),
          _StatItem(
            icon: Icons.school,
            value: '${stats.wordsLearned}',
            label: 'Words',
            color: Colors.lightGreenAccent,
          ),
          _StatItem(
            icon: Icons.favorite,
            value: '${stats.hearts}',
            label: 'Hearts',
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
