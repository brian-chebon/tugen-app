import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/l10n/app_localizations.dart';

/// Loading shimmer placeholder for lists
class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

/// Large play button used across features
class PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final double size;

  const PlayButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// XP gained animation badge
class XpBadge extends StatelessWidget {
  final int xp;
  const XpBadge({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            '+$xp XP',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Offline indicator banner
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: Colors.orange.shade800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).offlineBanner,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Heart display widget
class HeartsDisplay extends StatelessWidget {
  final int hearts;
  final int maxHearts;

  const HeartsDisplay({
    super.key,
    required this.hearts,
    this.maxHearts = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxHearts, (i) {
        return Icon(
          i < hearts ? Icons.favorite : Icons.favorite_border,
          color: i < hearts ? Colors.redAccent : Colors.grey.shade400,
          size: 20,
        );
      }),
    );
  }
}

/// Streak flame widget
class StreakBadge extends StatelessWidget {
  final int streak;
  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.orange, size: 18),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
