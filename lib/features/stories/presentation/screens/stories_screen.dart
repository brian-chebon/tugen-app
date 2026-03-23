import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/stories_providers.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesProvider);
    final selectedDiff = ref.watch(selectedDifficultyProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stories)),
      body: Column(
        children: [
          // Difficulty filter chips
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.all,
                  selected: selectedDiff == null,
                  onTap: () => ref
                      .read(selectedDifficultyProvider.notifier)
                      .select(null),
                ),
                const SizedBox(width: 8),
                for (final diff in [
                  ('beginner', l10n.beginner),
                  ('intermediate', l10n.intermediate),
                  ('advanced', l10n.advanced),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: diff.$2,
                      selected: selectedDiff == diff.$1,
                      onTap: () => ref
                          .read(selectedDifficultyProvider.notifier)
                          .select(diff.$1),
                    ),
                  ),
              ],
            ),
          ),

          // Stories list
          Expanded(
            child: stories.when(
              data: (list) {
                final filtered = selectedDiff != null
                    ? list
                        .where((s) => s.difficulty == selectedDiff)
                        .toList()
                    : list;

                if (filtered.isEmpty) {
                  return Center(child: Text(l10n.noStories));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final story = filtered[i];
                    return _StoryCard(
                      story: story,
                      onTap: () =>
                          context.go('/stories/play/${story.id}'),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const _StoryCard({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = (story.durationSeconds / 60).ceil();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Cover image or icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.titleEn,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.titleTug,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('$minutes min',
                            style: theme.textTheme.bodySmall),
                        const SizedBox(width: 12),
                        _DifficultyBadge(difficulty: story.difficulty),
                        if (story.isDownloaded) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.download_done,
                              size: 14, color: Colors.green.shade600),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_outline, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = switch (difficulty) {
      'beginner' => Colors.green,
      'intermediate' => Colors.orange,
      'advanced' => Colors.red,
      _ => Colors.grey,
    };
    final label = switch (difficulty) {
      'beginner' => l10n.beginner,
      'intermediate' => l10n.intermediate,
      'advanced' => l10n.advanced,
      _ => difficulty,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
