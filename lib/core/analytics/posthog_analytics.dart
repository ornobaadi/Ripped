import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ripped/core/analytics/analytics.dart';

/// Sends the funnel events to PostHog over plain HTTPS (no SDK, so nothing
/// is collected automatically). Events carry a random install id, never the
/// account, and only allow-listed props.
///
/// Best effort: events wait in memory and go out in batches, off the UI
/// path. Nothing is sent while [enabled] is false.
class PostHogAnalytics implements Analytics {
  new({
    required this.apiKey,
    required this.host,
    required this.installId,
    required this.client,
    this.appProps = const {},
    this.flushDelay = const Duration(seconds: 10),
    this.now = DateTime.now,
  });

  final String apiKey;
  final String host;

  /// Resolves the random per-install id (created on first use).
  final Future<String> Function() installId;

  /// Static context on every event (app version, flavor).
  final Map<String, Object> appProps;
  final Duration flushDelay;
  final http.Client client;
  final DateTime Function() now;

  /// The user's choice in You > Data & privacy.
  bool enabled = true;

  static const _maxQueue = 200;
  final _queue = <Map<String, Object>>[];
  Timer? _timer;
  bool _sending = false;

  @visibleForTesting
  int get pending => _queue.length;

  @override
  void track(AnalyticsEvent event, [Map<String, Object> props = const {}]) {
    if (!enabled) return;
    if (_queue.length >= _maxQueue) _queue.removeAt(0);
    _queue.add({
      'event': event.name,
      'timestamp': now().toUtc().toIso8601String(),
      'properties': {
        ...appProps,
        ...sanitizeAnalyticsProps(props),
        // No person profiles, no IP-based location.
        r'$process_person_profile': false,
        r'$geoip_disable': true,
      },
    });
    _timer ??= Timer(flushDelay, () => unawaited(flush()));
  }

  /// Sends what's waiting. Failures keep the events for the next try.
  Future<void> flush() async {
    _timer?.cancel();
    _timer = null;
    if (_sending || _queue.isEmpty) return;
    if (!enabled) {
      _queue.clear();
      return;
    }
    _sending = true;
    final batch = List.of(_queue);
    try {
      final id = await installId();
      final res = await client
          .post(
            Uri.parse('$host/batch/'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode({
              'api_key': apiKey,
              'batch': [
                for (final e in batch) {...e, 'distinct_id': id},
              ],
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode < 300) _queue.removeRange(0, batch.length);
    } on Object {
      // Offline or blocked: try again with the next event.
    } finally {
      _sending = false;
    }
  }
}
