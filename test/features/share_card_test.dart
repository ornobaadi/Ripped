import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/features/progress/presentation/share_card.dart';

import '../helpers/golden.dart';

void main() {
  final data = ShareCardData(
    weekStart: DateTime(2026, 10, 5),
    volume: '8,400 kg',
    workouts: 4,
    sets: 62,
    minutes: 195,
    trainedWeekdays: const {1, 2, 4, 5},
    streakWeeks: 3,
    topMuscle: 'Legs',
    changePercent: 12,
  );

  for (final format in ShareFormat.values) {
    testWidgets('share card (${format.name}) keeps its shape and fits', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapForTest(
          SizedBox(
            width: 300,
            child: ShareCard(data: data, format: format),
          ),
        ),
      );
      // Any overflow inside the card fails the test.
      expect(tester.takeException(), isNull);
      final size = tester.getSize(find.byType(ShareCard));
      expect(size.width / size.height, closeTo(format.aspect, 0.01));
      expect(find.text('RIPPED'), findsOneWidget);
      expect(find.text('8,400 kg'), findsOneWidget);
      expect(find.text('3h 15m'), findsOneWidget);
      expect(find.textContaining('Most trained: Legs'), findsOneWidget);
      // 1080 px wide when exported.
      expect(ShareFormat.pixelWidth / format.aspect, format.pixelHeight);
    });
  }

  goldenTest(
    'share_card_post',
    () => SizedBox(
      width: 300,
      child: ShareCard(data: data, format: ShareFormat.post),
    ),
    size: const Size(340, 420),
  );
}
