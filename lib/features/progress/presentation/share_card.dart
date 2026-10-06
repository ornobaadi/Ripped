import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/schedule.dart';
import 'package:ripped/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

/// What the weekly share card shows. Totals only: nothing that identifies
/// the person.
class ShareCardData {
  const new({
    required this.weekStart,
    required this.volume,
    required this.workouts,
    required this.sets,
    required this.minutes,
    required this.trainedWeekdays,
    this.streakWeeks = 0,
    this.topMuscle,
    this.changePercent,
  });

  final DateTime weekStart;

  /// Already formatted with the user's unit, e.g. "8,400 kg".
  final String volume;
  final int workouts;
  final int sets;
  final int minutes;

  /// 1 = Monday … 7 = Sunday.
  final Set<int> trainedWeekdays;
  final int streakWeeks;
  final String? topMuscle;

  /// Volume change vs last week in percent, when there is one.
  final int? changePercent;
}

enum ShareFormat {
  /// 4:5, the tallest a feed post can be (1080 x 1350).
  post(4 / 5, 1350),

  /// 9:16 for stories and status (1080 x 1920).
  story(9 / 16, 1920);

  new(this.aspect, this.pixelHeight);

  final double aspect;
  final int pixelHeight;
  static const pixelWidth = 1080;
}

/// The branded card. Always in the app's dark colours with the lime accent,
/// whatever theme the phone is in, so shared images look like Ripped.
class ShareCard extends StatelessWidget {
  const new({required this.data, required this.format, super.key});

  final ShareCardData data;
  final ShareFormat format;

  static const AppColors _c = AppColors.dark;
  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final end = Schedule.addDays(data.weekStart, 6);
    final range =
        '${DateFormat.MMMd().format(data.weekStart)} – '
        '${DateFormat.MMMd().format(end)}';
    final hours = data.minutes ~/ 60;
    final time = hours == 0
        ? l10n.minutesShort(data.minutes)
        : l10n.hoursMinutes(hours, data.minutes % 60);
    final notes = [
      if (data.streakWeeks > 0) l10n.streakWeeks(data.streakWeeks),
      if (data.topMuscle != null) l10n.shareTopMuscle(data.topMuscle!),
      if (data.changePercent != null && data.changePercent! > 0)
        l10n.recapUp(data.changePercent!),
    ];

    TextStyle display(double size, {Color? color, double? spacing}) =>
        TextStyle(
          fontFamily: AppFonts.display,
          fontWeight: FontWeight.w700,
          fontSize: size,
          height: 1,
          letterSpacing: spacing,
          color: color ?? _c.textPrimary,
        );
    TextStyle body(double size, {Color? color}) => TextStyle(
      fontFamily: AppFonts.ui,
      fontSize: size,
      height: 1.3,
      color: color ?? _c.textSecondary,
    );

    // Drawn on a fixed 360-wide canvas and scaled, so the picture is the
    // same on every phone and at every text size.
    return AspectRatio(
      aspectRatio: format.aspect,
      child: FittedBox(
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.noScaling),
          child: SizedBox(
            width: 360,
            height: 360 / format.aspect,
            child: DecoratedBox(
              decoration: BoxDecoration(color: _c.bg),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _Backdrop(_c)),
                  ),
                  Positioned(
                    right: -36,
                    bottom: 40,
                    child: Transform.rotate(
                      angle: -math.pi / 7,
                      child: Icon(
                        Symbols.exercise_rounded,
                        size: 220,
                        color: _c.textPrimary.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('RIPPED', style: display(26, spacing: 3)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(range, style: body(13)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 2),
                        Text(
                          l10n.shareHeadline.toUpperCase(),
                          style: body(13, color: _c.textSecondary).copyWith(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.volume,
                            style: display(92, color: _c.accent),
                          ),
                        ),
                        Text(l10n.shareLifted, style: body(16)),
                        const Spacer(),
                        Row(
                          children: [
                            for (final (value, label) in [
                              ('${data.workouts}', l10n.recapWorkouts),
                              ('${data.sets}', l10n.recapSets),
                              (time, l10n.recapTime),
                            ])
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(value, style: display(36)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(label, style: body(12)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            for (var d = 1; d <= 7; d++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Container(
                                    height: 34,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: data.trainedWeekdays.contains(d)
                                          ? _c.textPrimary
                                          : _c.surfaceRaised,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _letters[d - 1],
                                      style: body(
                                        13,
                                        color: data.trainedWeekdays.contains(d)
                                            ? _c.bg
                                            : _c.textSecondary,
                                      ).copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (notes.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            notes.join('  ·  '),
                            style: body(13, color: _c.textPrimary),
                          ),
                        ],
                        const Spacer(flex: 2),
                        Text(l10n.shareTagline, style: body(12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A soft lime glow in the top corner and a thin accent rule: enough to
/// feel designed without competing with the numbers.
class _Backdrop extends CustomPainter {
  const new(this.c);

  final AppColors c;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Offset(size.width * 0.95, size.height * 0.05);
    canvas
      ..drawCircle(
        glow,
        size.width * 0.9,
        Paint()
          ..shader = ui.Gradient.radial(glow, size.width * 0.9, [
            c.accent.withValues(alpha: 0.22),
            c.accent.withValues(alpha: 0),
          ]),
      )
      ..drawRect(
        Rect.fromLTWH(0, 0, 5, size.height),
        Paint()..color = c.accent,
      );
  }

  @override
  bool shouldRepaint(_Backdrop old) => false;
}

/// Preview the card, choose post or story shape, then share or save it
/// through the phone's share sheet.
Future<void> showShareCardSheet(
  BuildContext context, {
  required ShareCardData data,
  required String text,
}) => showAppSheet<void>(
  context,
  scrollable: true,
  builder: (_) => _ShareCardSheet(data: data, text: text),
);

class _ShareCardSheet extends StatefulWidget {
  const new({required this.data, required this.text});

  final ShareCardData data;
  final String text;

  @override
  State<_ShareCardSheet> createState() => _ShareCardSheetState();
}

class _ShareCardSheetState extends State<_ShareCardSheet> {
  final GlobalKey _key = GlobalKey();
  ShareFormat _format = ShareFormat.post;
  bool _busy = false;

  Future<void> _share() async {
    setState(() => _busy = true);
    final files = <XFile>[];
    try {
      final boundary =
          _key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      // Exactly 1080 px wide whatever the preview size.
      final image = await boundary.toImage(
        pixelRatio: ShareFormat.pixelWidth / boundary.size.width,
      );
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (png != null) {
        files.add(
          XFile.fromData(png.buffer.asUint8List(), mimeType: 'image/png'),
        );
      }
    } on Object {
      // No picture: the text still goes out.
    }
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: widget.text,
          files: files.isEmpty ? null : files,
          fileNameOverrides: files.isEmpty ? null : ['ripped-week.png'],
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SegmentedButton<ShareFormat>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ShareFormat.post,
                  label: Text(l10n.shareFormatPost),
                ),
                ButtonSegment(
                  value: ShareFormat.story,
                  label: Text(l10n.shareFormatStory),
                ),
              ],
              selected: {_format},
              onSelectionChanged: (s) => setState(() => _format = s.first),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.card),
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    key: _key,
                    child: ShareCard(data: widget.data, format: _format),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.shareAction,
            onPressed: _busy ? null : () => unawaited(_share()),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.shareHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
