import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/analytics/analytics.dart';

void main() {
  test('only allow-listed, non-identifying props survive', () {
    final clean = sanitizeAnalyticsProps({
      'sets': 18,
      'leveled_up': true,
      'goal': 'muscle',
      'weight_kg': 100,
      'email': 'a@b.c',
      'name': 'Alex',
      'experience': 'x' * 40,
    });
    expect(clean, {'sets': 18, 'leveled_up': true, 'goal': 'muscle'});
  });

  test('debug analytics never throws', () {
    const DebugAnalytics().track(AnalyticsEvent.workoutCompleted, {'sets': 3});
  });
}
