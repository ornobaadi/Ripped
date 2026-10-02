import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/design/components/components.dart';

import '../../helpers/golden.dart';

void main() {
  testWidgets('ValueStepper steps and clamps', (tester) async {
    var value = 1.0;
    await tester.pumpWidget(
      wrapForTest(
        StatefulBuilder(
          builder: (context, setState) => ValueStepper(
            label: 'Reps',
            value: value,
            max: 2,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Increase Reps'));
    await tester.pump();
    expect(value, 2);

    // At max: increase is disabled.
    await tester.tap(find.byTooltip('Increase Reps'));
    await tester.pump();
    expect(value, 2);

    await tester.tap(find.byTooltip('Decrease Reps'));
    await tester.pump();
    expect(value, 1);
  });

  testWidgets('SetRow toggles and exposes semantics', (tester) async {
    final handle = tester.ensureSemantics();
    var toggled = false;
    await tester.pumpWidget(
      wrapForTest(
        SetRow(
          setNumber: 2,
          load: '60 kg × 8',
          done: false,
          onToggle: () => toggled = true,
        ),
      ),
    );

    expect(find.bySemanticsLabel('Mark set 2 done'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Mark set 2 done'));
    expect(toggled, isTrue);
    handle.dispose();
  });

  testWidgets('ChoiceCard reports selected state', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      wrapForTest(
        ChoiceCard(title: 'Build muscle', selected: true, onTap: () {}),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Build muscle')),
      matchesSemantics(
        label: 'Build muscle',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('buttons meet tap target guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      wrapForTest(
        Column(
          children: [
            AppButton(label: 'Go', onPressed: () {}),
            ValueStepper(label: 'Reps', value: 5, onChanged: (_) {}),
          ],
        ),
      ),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
