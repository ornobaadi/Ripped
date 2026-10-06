import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/app/router.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/analytics/posthog_analytics.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/sync/sync_controller.dart';
import 'package:ripped/l10n/l10n.dart';

class RippedApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<RippedApp> createState() => _RippedAppState();
}

class _RippedAppState extends ConsumerState<RippedApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Back up in the background: once after launch, then on every resume.
    _lifecycle = AppLifecycleListener(onResume: _sync, onPause: _flush);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sync();
      ref.read(analyticsProvider).track(AnalyticsEvent.appOpened);
    });
  }

  /// Leaving the app is the last safe moment to send waiting events.
  void _flush() {
    final analytics = ref.read(analyticsProvider);
    if (analytics is PostHogAnalytics) unawaited(analytics.flush());
  }

  void _sync() =>
      unawaited(ref.read(syncControllerProvider.notifier).requestSync());

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Dark by default (design.md 5.1); changed in You > Appearance.
      themeMode: ThemeMode.values.byName(
        ref.watch(themeProvider).value ?? ref.watch(initialThemeProvider),
      ),
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.overlay(Theme.of(context).brightness),
        child: child!,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
