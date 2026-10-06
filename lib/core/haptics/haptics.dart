import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Moments the phone answers with touch. Each has one meaning, so the
/// feel tells you what happened without looking.
enum HapticCue {
  /// Small controls: steppers, tabs, toggles.
  tap,

  /// A set was logged.
  setDone,

  /// An exercise is finished; moving on.
  exerciseDone,

  /// Rest is over: time for the next set.
  restOver,

  /// The workout was saved.
  workoutDone,

  /// A record, a level or a badge.
  celebrate,
}

/// The app's only door to vibration, so one switch (You > Haptics) turns
/// all of it off. Never throws: a phone without a motor just stays quiet.
abstract final class Haptics {
  /// The user's choice. Set from settings at startup and on change.
  static bool enabled = true;

  /// Replaced in tests to record cues instead of buzzing.
  @visibleForTesting
  static void Function(HapticCue cue)? observer;

  /// (wait ms, buzz ms, ...) and strength 1-255 for the stronger cues.
  static const _patterns = <HapticCue, (List<int>, int)>{
    HapticCue.setDone: ([0, 45], 180),
    HapticCue.exerciseDone: ([0, 60, 90, 60], 200),
    HapticCue.restOver: ([0, 120, 110, 120], 255),
    HapticCue.workoutDone: ([0, 90, 80, 90, 80, 320], 255),
    HapticCue.celebrate: ([0, 50, 60, 50, 60, 50, 60, 220], 255),
  };

  static void play(HapticCue cue) {
    if (!enabled) return;
    if (observer case final watch?) {
      watch(cue);
      return;
    }
    unawaited(_play(cue));
  }

  static Future<void> _play(HapticCue cue) async {
    final pattern = _patterns[cue];
    try {
      if (pattern == null || kIsWeb) {
        await HapticFeedback.selectionClick();
        return;
      }
      final (timings, strength) = pattern;
      if (await Vibration.hasVibrator()) {
        final shaped = await Vibration.hasAmplitudeControl();
        await Vibration.vibrate(
          pattern: timings,
          intensities: shaped
              ? [
                  for (var i = 0; i < timings.length; i++)
                    if (i.isEven) 0 else strength,
                ]
              : const [],
        );
        return;
      }
      await _fallback(cue);
    } on Object {
      // Plugin missing (tests, desktop) or the motor refused: fall back.
      try {
        await _fallback(cue);
      } on Object {
        // Nothing more to try.
      }
    }
  }

  static Future<void> _fallback(HapticCue cue) => switch (cue) {
    HapticCue.tap => HapticFeedback.selectionClick(),
    HapticCue.setDone => HapticFeedback.mediumImpact(),
    _ => HapticFeedback.heavyImpact(),
  };
}
