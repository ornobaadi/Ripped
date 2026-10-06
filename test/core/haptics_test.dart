import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/haptics/haptics.dart';

void main() {
  final played = <HapticCue>[];

  setUp(() {
    played.clear();
    Haptics.enabled = true;
    Haptics.observer = played.add;
  });

  tearDown(() {
    Haptics.observer = null;
    Haptics.enabled = true;
  });

  test('plays cues while enabled', () {
    Haptics.play(HapticCue.setDone);
    Haptics.play(HapticCue.workoutDone);
    expect(played, [HapticCue.setDone, HapticCue.workoutDone]);
  });

  test('stays silent when the user turned it off', () {
    Haptics.enabled = false;
    HapticCue.values.forEach(Haptics.play);
    expect(played, isEmpty);
  });

  testWidgets('never throws without a vibration motor', (tester) async {
    Haptics.observer = null;
    HapticCue.values.forEach(Haptics.play);
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
  });
}
