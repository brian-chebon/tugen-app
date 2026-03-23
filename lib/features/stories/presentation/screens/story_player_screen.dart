import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/audio/audio_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/progress_dao.dart';
import '../../../../core/database/daos/stories_dao.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/stories_providers.dart';

class StoryPlayerScreen extends ConsumerStatefulWidget {
  final String storyId;
  const StoryPlayerScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends ConsumerState<StoryPlayerScreen> {
  Story? _story;
  bool _showTranslation = true;
  double _speed = 1.0;
  bool _completionTracked = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  Future<void> _loadStory() async {
    final dao = StoriesDao(ref.read(databaseProvider));
    final story = await dao.getStory(widget.storyId);
    setState(() => _story = story);

    if (story != null) {
      final audioService = ref.read(audioServiceProvider);
      audioService.play(
        story.audioPath ?? '',
        remoteUrl: story.audioUrl,
      );

      // Listen for completion
      audioService.player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed &&
            !_completionTracked) {
          _completionTracked = true;
          ProgressDao(ref.read(databaseProvider)).incrementStoriesCompleted();
        }
      });
    }
  }

  Future<void> _downloadStory() async {
    if (_story == null || _story!.audioUrl == null) return;
    setState(() => _isDownloading = true);

    try {
      final audioService = ref.read(audioServiceProvider);
      final localPath = await audioService.downloadAudio(
        _story!.audioUrl!,
        'story_${_story!.id}.aac',
      );

      final dao = StoriesDao(ref.read(databaseProvider));
      await dao.markDownloaded(_story!.id, localPath);

      // Refresh story state
      final updated = await dao.getStory(widget.storyId);
      if (mounted) setState(() => _story = updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = ref.watch(audioServiceProvider);
    final segments = ref.watch(storySegmentsProvider(widget.storyId));
    final l10n = AppLocalizations.of(context);

    if (_story == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_story!.titleEn),
        actions: [
          // Toggle translation
          IconButton(
            icon: Icon(
              Icons.translate,
              color: _showTranslation ? theme.colorScheme.primary : null,
            ),
            tooltip: l10n.toggleTranslation,
            onPressed: () =>
                setState(() => _showTranslation = !_showTranslation),
          ),
        ],
      ),
      body: Column(
        children: [
          // Transcript with highlighted current segment
          Expanded(
            child: segments.when(
              data: (segs) => StreamBuilder<Duration?>(
                stream: audioService.positionStream,
                builder: (context, posSnap) {
                  final posMs =
                      (posSnap.data ?? Duration.zero).inMilliseconds;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: segs.length,
                    itemBuilder: (context, i) {
                      final seg = segs[i];
                      final isActive =
                          posMs >= seg.startMs && posMs < seg.endMs;

                      return GestureDetector(
                        onTap: () {
                          audioService
                              .seek(Duration(milliseconds: seg.startMs));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.colorScheme.primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: isActive
                                ? Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 1.5)
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seg.tugen,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isActive
                                      ? theme
                                          .colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              if (_showTranslation) ...[
                                const SizedBox(height: 6),
                                Text(
                                  seg.english,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme
                                        .colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),

          // Player controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Progress bar
                StreamBuilder<Duration?>(
                  stream: audioService.positionStream,
                  builder: (context, snap) {
                    final pos = snap.data ?? Duration.zero;
                    final dur = audioService.duration;
                    final progress = dur.inMilliseconds > 0
                        ? pos.inMilliseconds / dur.inMilliseconds
                        : 0.0;

                    return Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape:
                                const RoundSliderOverlayShape(
                                    overlayRadius: 14),
                            activeTrackColor:
                                theme.colorScheme.primary,
                            inactiveTrackColor:
                                theme.colorScheme.outlineVariant,
                            thumbColor: theme.colorScheme.primary,
                          ),
                          child: Slider(
                            value: progress.clamp(0.0, 1.0),
                            onChanged: (v) {
                              final seekPos = Duration(
                                  milliseconds:
                                      (v * dur.inMilliseconds)
                                          .round());
                              audioService.seek(seekPos);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(pos),
                                style: theme.textTheme.bodySmall),
                            Text(_formatDuration(dur),
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),

                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Speed
                    TextButton(
                      onPressed: () {
                        final speeds = [0.5, 0.7, 1.0, 1.25, 1.5];
                        final idx = speeds.indexOf(_speed);
                        final next =
                            speeds[(idx + 1) % speeds.length];
                        setState(() => _speed = next);
                        audioService.setSpeed(next);
                      },
                      child: Text('${_speed}x'),
                    ),

                    // Rewind 10s
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        final newPos = audioService.position -
                            const Duration(seconds: 10);
                        audioService.seek(
                            newPos < Duration.zero
                                ? Duration.zero
                                : newPos);
                      },
                    ),

                    // Play/Pause
                    StreamBuilder(
                      stream: audioService.playerStateStream,
                      builder: (context, snap) {
                        final playing = audioService.isPlaying;
                        return FloatingActionButton(
                          onPressed: () {
                            if (playing) {
                              audioService.pause();
                            } else {
                              audioService.resume();
                            }
                          },
                          child: Icon(
                            playing
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        );
                      },
                    ),

                    // Forward 10s
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        audioService.seek(
                          audioService.position +
                              const Duration(seconds: 10),
                        );
                      },
                    ),

                    // Download
                    _isDownloading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          )
                        : IconButton(
                            icon: Icon(
                              _story!.isDownloaded
                                  ? Icons.download_done
                                  : Icons.download,
                            ),
                            tooltip: _story!.isDownloaded
                                ? l10n.downloaded
                                : l10n.downloadForOffline,
                            onPressed:
                                _story!.isDownloaded
                                    ? null
                                    : _downloadStory,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
