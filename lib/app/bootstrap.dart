import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/app.dart';
import 'package:ripped/app/config.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/app/router.dart';
import 'package:ripped/core/auth/auth_service.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/haptics/haptics.dart';
import 'package:ripped/core/sync/supabase_sync_remote.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

/// Shared entry point for every flavor.
/// Does no network work (architecture.md 12).
Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment(flavor);

  // Draw behind transparent system bars; phone layouts are portrait-only.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Local data first: the catalog and the user's DB, in parallel.
  final db = AppDatabase();
  final (catalog, profile, theme, haptics) = await (
    CatalogRepository.load(),
    db.select(db.profiles).get(),
    SettingsRepository(db).theme(),
    SettingsRepository(db).hapticsEnabled(),
  ).wait;
  Haptics.enabled = haptics;
  final onboarded = profile.any((p) => p.onboardingDoneAt != null);
  // Not awaited: sign-in and backup come online in the background.
  final backend = _initBackend(config);

  final app = ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      databaseProvider.overrideWithValue(db),
      catalogProvider.overrideWithValue(catalog),
      initialOnboardedProvider.overrideWithValue(onboarded),
      initialThemeProvider.overrideWithValue(theme),
      backendProvider.overrideWith((ref) => backend),
    ],
    child: const RippedApp(),
  );

  if (config.sentryDsn.isEmpty) {
    FlutterError.onError = FlutterError.presentError;
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught: $error\n$stack');
      return true;
    };
    runApp(app);
    return;
  }

  // Crash reporting only when a DSN is configured for the flavor.
  await SentryFlutter.init(
    (o) => o
      ..dsn = config.sentryDsn
      ..environment = config.flavor.name
      ..sendDefaultPii = false
      ..attachScreenshot = false
      ..tracesSampleRate = 0,
    appRunner: () => runApp(app),
  );
}

/// Accounts are optional and never block startup: with no backend
/// configured, or if Supabase can't initialise quickly, the app runs offline.
Future<Backend> _initBackend(AppConfig config) async {
  if (!config.hasBackend) return Backend.offline;
  try {
    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabasePublishableKey,
    ).timeout(const Duration(seconds: 15));
    final client = Supabase.instance.client;
    return Backend(
      auth: SupabaseAuthService(client, config.googleWebClientId),
      remote: SupabaseSyncRemote(client),
    );
  } on Object catch (e) {
    debugPrint('Backend unavailable, continuing offline: ${e.runtimeType}');
    return Backend.offline;
  }
}
