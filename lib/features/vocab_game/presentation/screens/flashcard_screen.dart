import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

import '../../../../core/audio/audio_service.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/usecases/review_service.dart';
import '../providers/vocab_providers.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final String deckId;
  const FlashcardScreen({super.key, required this.deckId});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  List<VocabCard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final dao = ref.read(vocabDaoProvider);
    List<VocabCard> cards;

    if (widget.deckId == 'due') {
      cards = await dao.getDueCards();
    } else {
      cards = await (await dao.watchCardsByDeck(widget.deckId).first);
    }

    setState(() {
      _cards = cards..shuffle();
      _isLoading = false;
    });
  }

  void _onRate(fsrs.Rating rating) async {
    if (_currentIndex >= _cards.length) return;

    final card = _cards[_currentIndex];
    final reviewService = ref.read(reviewServiceProvider);
    await reviewService.reviewCard(card.id, 'vocab', rating);

    setState(() {
      _isFlipped = false;
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = ref.watch(audioServiceProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcards')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcards')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
              SizedBox(height: 16),
              Text('All caught up!', style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text('No cards due for review.'),
            ],
          ),
        ),
      );
    }

    if (_currentIndex >= _cards.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Complete!')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                'Session Complete!',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text('Reviewed ${_cards.length} cards'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
    }

    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${_cards.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _cards.length,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Card
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isFlipped = !_isFlipped),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey('$_currentIndex-$_isFlipped'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isFlipped) ...[
                          Text(
                            card.tugen,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 36),
                            onPressed: () => audioService.play(
                              card.audioPath ?? '',
                              remoteUrl: card.audioUrl,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap to reveal',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ] else ...[
                          Text(
                            card.english,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            card.swahili,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Rating buttons (show only when flipped)
            if (_isFlipped)
              Row(
                children: [
                  _RatingButton(
                    label: 'Again',
                    color: Colors.red,
                    onTap: () => _onRate(fsrs.Rating.again),
                  ),
                  const SizedBox(width: 8),
                  _RatingButton(
                    label: 'Hard',
                    color: Colors.orange,
                    onTap: () => _onRate(fsrs.Rating.hard),
                  ),
                  const SizedBox(width: 8),
                  _RatingButton(
                    label: 'Good',
                    color: Colors.green,
                    onTap: () => _onRate(fsrs.Rating.good),
                  ),
                  const SizedBox(width: 8),
                  _RatingButton(
                    label: 'Easy',
                    color: Colors.blue,
                    onTap: () => _onRate(fsrs.Rating.easy),
                  ),
                ],
              )
            else
              const SizedBox(height: 52), // Placeholder height
          ],
        ),
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
