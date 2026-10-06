import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

/// The exercise demo: a muted, looping video baked onto the tile colour of
/// the current theme, so it sits flush in the card. Exercises without a
/// video crossfade their still images instead.
///
/// Reduce Motion: shows the still; tap to play. Tapping always toggles.
class ExerciseMotion extends StatelessWidget {
  const new({required this.exercise, super.key});

  final Exercise exercise;

  /// Platform video isn't available in widget tests; the still is shown.
  @visibleForTesting
  static bool videoEnabled = !const bool.fromEnvironment('FLUTTER_TEST');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final video = exercise.videoFor(Theme.of(context).brightness.name);
    final stills = exercise.stills;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: video != null
            ? ColoredBox(
                color: c.surfaceRaised,
                child: _VideoLoop(video: video),
              )
            : stills.isEmpty
            ? ColoredBox(color: c.surfaceRaised)
            : ColoredBox(
                // Source photos have a white background.
                color: Colors.white,
                child: _FrameLoop(uris: [for (final m in stills) m.uri]),
              ),
      ),
    );
  }
}

class _VideoLoop extends StatefulWidget {
  const new({required this.video});

  final ExerciseMedia video;

  @override
  State<_VideoLoop> createState() => _VideoLoopState();
}

class _VideoLoopState extends State<_VideoLoop> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _paused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _paused = MediaQuery.disableAnimationsOf(context);
    _load();
  }

  @override
  void didUpdateWidget(_VideoLoop old) {
    super.didUpdateWidget(old);
    // Theme switch: the other baked variant.
    if (old.video.uri != widget.video.uri) _load();
  }

  void _load() {
    if (!ExerciseMotion.videoEnabled) return;
    if (_controller?.dataSource == widget.video.uri) {
      unawaited(_paused ? _controller!.pause() : _controller!.play());
      return;
    }
    final old = _controller;
    _ready = false;
    final controller = _controller = VideoPlayerController.asset(
      widget.video.uri,
      // Never interrupt the user's music.
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    unawaited(old?.dispose());
    unawaited(_start(controller));
  }

  Future<void> _start(VideoPlayerController controller) async {
    try {
      await controller.initialize();
      await controller.setVolume(0);
      await controller.setLooping(true);
      if (!_paused) await controller.play();
    } on Object catch (e) {
      debugPrint('Exercise video failed: $e');
      return;
    }
    if (mounted && controller == _controller) setState(() => _ready = true);
  }

  void _toggle() {
    final controller = _controller;
    if (controller == null || !_ready) return;
    setState(() => _paused = !_paused);
    unawaited(_paused ? controller.pause() : controller.play());
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final controller = _controller;
    return Semantics(
      button: _ready,
      label: _ready
          ? (_paused ? context.l10n.playDemo : context.l10n.pauseDemo)
          : null,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: _toggle,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster first, so there's never an empty box while loading.
            if (widget.video.thumbUri case final thumb?)
              Image.asset(
                thumb,
                fit: BoxFit.contain,
                cacheWidth: (MediaQuery.sizeOf(context).width * dpr).round(),
                gaplessPlayback: true,
              ),
            if (controller != null)
              AnimatedOpacity(
                opacity: _ready ? 1 : 0,
                duration: AppMotion.fast,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
            if (_ready && _paused)
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.bg.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Icon(
                      Symbols.play_arrow_rounded,
                      fill: 1,
                      color: c.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Crossfades start/end frames on a loop: a lightweight "animation" from
/// still images. Holds still when the system asks for reduced motion.
class _FrameLoop extends StatefulWidget {
  const new({required this.uris});

  final List<String> uris;

  @override
  State<_FrameLoop> createState() => _FrameLoopState();
}

class _FrameLoopState extends State<_FrameLoop> {
  Timer? _timer;
  int _frame = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (widget.uris.length > 1 && !MediaQuery.disableAnimationsOf(context)) {
      _timer = Timer.periodic(
        const Duration(milliseconds: 1400),
        (_) => setState(() => _frame = (_frame + 1) % widget.uris.length),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return ExcludeSemantics(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: Image.asset(
          widget.uris[_frame],
          key: ValueKey(_frame),
          fit: BoxFit.contain,
          width: double.infinity,
          cacheWidth: (width * dpr).round(),
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
