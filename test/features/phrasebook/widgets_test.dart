import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tugen_app/shared/widgets/common_widgets.dart';

void main() {
  group('HeartsDisplay Widget', () {
    testWidgets('shows correct number of filled hearts', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HeartsDisplay(hearts: 3)),
        ),
      );

      final filledHearts = find.byIcon(Icons.favorite);
      final emptyHearts = find.byIcon(Icons.favorite_border);

      expect(filledHearts, findsNWidgets(3));
      expect(emptyHearts, findsNWidgets(2));
    });

    testWidgets('shows all empty when hearts is 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HeartsDisplay(hearts: 0)),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.byIcon(Icons.favorite_border), findsNWidgets(5));
    });
  });

  group('XpBadge Widget', () {
    testWidgets('displays correct XP value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: XpBadge(xp: 25)),
        ),
      );

      expect(find.text('+25 XP'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('StreakBadge Widget', () {
    testWidgets('displays streak count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StreakBadge(streak: 7)),
        ),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });
  });

  group('PlayButton Widget', () {
    testWidgets('shows play icon when not playing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayButton(isPlaying: false, onTap: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('shows pause icon when playing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayButton(isPlaying: true, onTap: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayButton(
              isPlaying: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PlayButton));
      expect(tapped, isTrue);
    });
  });
}
