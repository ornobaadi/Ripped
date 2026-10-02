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
import 'package:ripped/core/design/theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('Overridden in bootstrap'),
);

/// Shared entry point for every flavor.
/// Does no network work (architecture.md 12).
Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment(flavor);

  // Draw behind transparent system bars; phone layouts are portrait-only.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppSystemUi.overlay);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Local data first: the catalog and the user's DB, in parallel.
  final db = AppDatabase();
  final (catalog, profile) = await (
    CatalogRepository.load(),
    db.select(db.profiles).get(),
  ).wait;
  final onboarded = profile.any((p) => p.onboardingDoneAt != null);
  final auth = await _initAuth(config);

  final app = ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      databaseProvider.overrideWithValue(db),
      catalogProvider.overrideWithValue(catalog),
      initialOnboardedProvider.overrideWithValue(onboarded),
      authServiceProvider.overrideWithValue(auth),
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
Future<AuthService> _initAuth(AppConfig config) async {
  if (!config.hasBackend) return const OfflineAuthService();
  try {
    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabasePublishableKey,
    ).timeout(const Duration(seconds: 3));
    return SupabaseAuthService(
      Supabase.instance.client,
      config.googleWebClientId,
    );
  } on Object catch (e) {
    debugPrint('Auth unavailable, continuing offline: ${e.runtimeType}');
    return const OfflineAuthService();
  }
}
