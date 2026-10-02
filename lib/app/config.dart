enum AppFlavor { dev, staging, prod }

/// Build-time configuration, supplied via
/// `--dart-define-from-file=env/<flavor>.json`.
/// Only public values belong here (Supabase URL + publishable key, Google
/// web client ID). Never secret or service-role keys.
class AppConfig {
  const new({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabasePublishableKey,
    required this.sentryDsn,
    required this.googleWebClientId,
  });

  factory fromEnvironment(AppFlavor flavor) => AppConfig(
    flavor: flavor,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabasePublishableKey: const String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    ),
    sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
    googleWebClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
  );

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabasePublishableKey;
  final String sentryDsn;

  /// OAuth client ID of type "Web application" (not the Android one).
  final String googleWebClientId;

  bool get isProd => flavor == AppFlavor.prod;

  /// Accounts are optional: without a backend the app is fully offline.
  bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  bool get hasGoogleSignIn => hasBackend && googleWebClientId.isNotEmpty;
}
