import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/components/plan_animation.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/plan_summary.dart';
import 'package:ripped/features/plan/presentation/plan_labels.dart';
import 'package:ripped/l10n/l10n.dart';

/// Time each line takes to tick off. Zero in tests.
final planBuildPaceProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 650),
);

/// The moment the plan is put together: an animation and the person's own
/// answers ticking off one by one. The real save runs underneath.
class PlanBuildingView extends ConsumerStatefulWidget {
  const new({required this.summary, super.key});

  final PlanSummary summary;

  /// How long the view needs before moving on.
  static Duration duration(int steps, Duration pace, {required bool still}) =>
      still ? pace : pace * (steps + 1);

  @override
  ConsumerState<PlanBuildingView> createState() => _PlanBuildingViewState();
}

class _PlanBuildingViewState extends ConsumerState<PlanBuildingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(vsync: this);
  int _steps = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final steps = widget.summary.buildSteps(context.l10n).length;
    if (_steps == steps) return;
    _steps = steps;
    final pace = ref.read(planBuildPaceProvider);
    if (MediaQuery.disableAnimationsOf(context) || pace == Duration.zero) {
      _t.value = 1;
    } else {
      _t
        ..duration = pace * steps
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final steps = widget.summary.buildSteps(l10n);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PlanAnimation(name: 'building'),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.buildingPlan,
                  style: text.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                AnimatedBuilder(
                  animation: _t,
                  builder: (context, _) {
                    final done = (_t.value * steps.length).floor();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (i, step) in steps.indexed)
                          AnimatedOpacity(
                            duration: AppMotion.base,
                            opacity: i <= done ? 1 : 0.35,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xs,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    i < done
                                        ? Symbols.check_circle_rounded
                                        : Symbols.circle_rounded,
                                    fill: i < done ? 1 : 0,
                                    color: i < done ? c.success : c.border,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(step, style: text.bodyLarge),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
