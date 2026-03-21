import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/audio/audio_service.dart';
import '../providers/phrasebook_providers.dart';

class CategoryScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrases = ref.watch(phrasesByCategoryProvider(categoryId));
    final audioService = ref.watch(audioServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phrases'),
      ),
      body: phrases.when(
        data: (list) => list.isEmpty
            ? const Center(child: Text('No phrases yet'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final phrase = list[index];
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          context.go('/phrasebook/phrase/${phrase.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Play button
                            IconButton(
                              icon: const Icon(Icons.play_circle_fill, size: 40),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                audioService.play(
                                  phrase.audioPath ?? '',
                                  remoteUrl: phrase.audioUrl,
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            // Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    phrase.tugen,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    phrase.english,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  if (phrase.swahili.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      phrase.swahili,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Difficulty indicator
                            _DifficultyDots(level: phrase.difficulty),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DifficultyDots extends StatelessWidget {
  final int level;
  const _DifficultyDots({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < level
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
