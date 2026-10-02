import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/router.dart';
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
    _lifecycle = AppLifecycleListener(onResume: _sync);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
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
      // Dark is the default (design.md 5.1). Follow system once settings land.
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
