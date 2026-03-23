import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/daos/phrases_dao.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/phrasebook_providers.dart';

class PhraseDetailScreen extends ConsumerStatefulWidget {
  final String phraseId;
  const PhraseDetailScreen({super.key, required this.phraseId});

  @override
  ConsumerState<PhraseDetailScreen> createState() => _PhraseDetailScreenState();
}

class _PhraseDetailScreenState extends ConsumerState<PhraseDetailScreen> {
  double _speed = AppConstants.defaultPlaybackSpeed;

  @override
  Widget build(BuildContext context) {
    final dao = PhrasesDao(ref.watch(databaseProvider));
    final audioService = ref.watch(audioServiceProvider);
    final isBookmarked = ref.watch(isBookmarkedProvider(widget.phraseId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          isBookmarked.when(
            data: (bookmarked) => IconButton(
              icon: Icon(
                bookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: bookmarked ? theme.colorScheme.primary : null,
              ),
              onPressed: () => dao.toggleBookmark(widget.phraseId),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: dao.getPhrase(widget.phraseId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final phrase = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),

                // Tugen text (large, prominent)
                Text(
                  phrase.tugen,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Pronunciation guide
                if (phrase.pronunciation != null)
                  Text(
                    '/${phrase.pronunciation}/',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 24),

                // Play button (big circular)
                StreamBuilder(
                  stream: audioService.playerStateStream,
                  builder: (context, snap) {
                    final playing = audioService.isPlaying;
                    return GestureDetector(
                      onTap: () {
                        if (playing) {
                          audioService.pause();
                        } else {
                          audioService.play(
                            phrase.audioPath ?? '',
                            remoteUrl: phrase.audioUrl,
                          );
                        }
                      },
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Speed control
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AppConstants.playbackSpeeds.map((speed) {
                    final isSelected = _speed == speed;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('${speed}x'),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _speed = speed);
                          audioService.setSpeed(speed);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Translations
                _TranslationRow(
                  label: AppLocalizations.of(context).english,
                  text: phrase.english,
                ),
                const SizedBox(height: 12),
                _TranslationRow(
                  label: AppLocalizations.of(context).swahili,
                  text: phrase.swahili,
                ),

                if (phrase.notes != null && phrase.notes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).notes,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(phrase.notes!),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Replay button
                OutlinedButton.icon(
                  onPressed: () => audioService.replay(),
                  icon: const Icon(Icons.replay),
                  label: Text(AppLocalizations.of(context).replay),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TranslationRow extends StatelessWidget {
  final String label;
  final String text;

  const _TranslationRow({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
