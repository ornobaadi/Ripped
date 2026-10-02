enum AppFlavor { dev, staging, prod }

/// Build-time configuration, supplied via
/// `--dart-define-from-file=env/<flavor>.json`.
/// Only public values belong here (e.g. Supabase anon key). Never secrets.
class AppConfig {
  const new({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.sentryDsn,
  });

  factory fromEnvironment(AppFlavor flavor) => AppConfig(
    flavor: flavor,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
  );

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String sentryDsn;

  bool get isProd => flavor == AppFlavor.prod;
}
