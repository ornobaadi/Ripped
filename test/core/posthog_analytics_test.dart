import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/analytics/posthog_analytics.dart';

void main() {
  late List<Map<String, dynamic>> bodies;
  var status = 200;

  PostHogAnalytics build() => PostHogAnalytics(
    apiKey: 'phc_test',
    host: 'https://example.test',
    installId: () async => 'install-1',
    appProps: const {'flavor': 'dev'},
    // Long enough that only explicit flushes send.
    flushDelay: const Duration(hours: 1),
    now: () => DateTime.utc(2026, 10, 6, 12),
    client: MockClient((request) async {
      expect(request.url.toString(), 'https://example.test/batch/');
      bodies.add(jsonDecode(request.body) as Map<String, dynamic>);
      return http.Response('{}', status);
    }),
  );

  setUp(() {
    bodies = [];
    status = 200;
  });

  test('sends a batch with the install id and only allowed props', () async {
    final analytics = build()
      ..track(AnalyticsEvent.workoutCompleted, {
        'sets': 12,
        'weight_kg': 100,
        'email': 'a@b.c',
      })
      ..track(AnalyticsEvent.appOpened);
    await analytics.flush();

    expect(bodies, hasLength(1));
    expect(bodies.single['api_key'], 'phc_test');
    final batch = (bodies.single['batch'] as List).cast<Map<String, dynamic>>();
    expect(batch.map((e) => e['event']), ['workoutCompleted', 'appOpened']);
    expect(batch.every((e) => e['distinct_id'] == 'install-1'), isTrue);
    final props = batch.first['properties'] as Map<String, dynamic>;
    expect(props['sets'], 12);
    expect(props['flavor'], 'dev');
    expect(props.containsKey('weight_kg'), isFalse);
    expect(props.containsKey('email'), isFalse);
    expect(props[r'$process_person_profile'], isFalse);
    expect(analytics.pending, 0);
  });

  test('keeps events when the request fails, then retries', () async {
    status = 500;
    final analytics = build()..track(AnalyticsEvent.signedIn);
    await analytics.flush();
    expect(analytics.pending, 1);

    status = 200;
    await analytics.flush();
    expect(analytics.pending, 0);
    expect(bodies, hasLength(2));
  });

  test('sends nothing when the user has turned it off', () async {
    final analytics = build()
      ..enabled = false
      ..track(AnalyticsEvent.appOpened);
    await analytics.flush();
    expect(bodies, isEmpty);

    // Turned off after events were queued: they are dropped, not sent.
    analytics
      ..enabled = true
      ..track(AnalyticsEvent.appOpened)
      ..enabled = false;
    await analytics.flush();
    expect(bodies, isEmpty);
    expect(analytics.pending, 0);
  });
}
