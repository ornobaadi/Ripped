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
    required this.supportEmail,
    required this.posthogKey,
    required this.posthogHost,
  });

  factory fromEnvironment(AppFlavor flavor) => AppConfig(
    flavor: flavor,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabasePublishableKey: const String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    ),
    sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
    googleWebClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    supportEmail: const String.fromEnvironment('SUPPORT_EMAIL'),
    posthogKey: const String.fromEnvironment('POSTHOG_KEY'),
    posthogHost: const String.fromEnvironment('POSTHOG_HOST'),
  );

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabasePublishableKey;
  final String sentryDsn;

  /// OAuth client ID of type "Web application" (not the Android one).
  final String googleWebClientId;

  /// Where "Send feedback" goes. Hidden when empty.
  final String supportEmail;

  /// PostHog project key (public, write-only). Analytics is off when empty.
  final String posthogKey;

  /// e.g. https://eu.i.posthog.com or https://us.i.posthog.com.
  final String posthogHost;

  bool get hasAnalytics => posthogKey.isNotEmpty && posthogHost.isNotEmpty;

  bool get isProd => flavor == AppFlavor.prod;

  /// Accounts are optional: without a backend the app is fully offline.
  bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  bool get hasGoogleSignIn => hasBackend && googleWebClientId.isNotEmpty;
}
