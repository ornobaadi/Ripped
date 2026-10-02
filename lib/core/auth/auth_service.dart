import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The signed-in person, as much as the UI needs. Nothing here is logged
/// or sent to analytics (CLAUDE.md rule 7).
@immutable
class AppUser {
  const new({required this.id, this.email, this.name, this.photoUrl});

  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;
}

enum SignInResult { success, cancelled, failed }

/// Accounts are optional (PRD 7.10): the app works fully without one.
abstract interface class AuthService {
  bool get isAvailable;
  AppUser? get currentUser;
  Stream<AppUser?> get userChanges;
  Future<SignInResult> signInWithGoogle();
  Future<void> signOut();

  /// Deletes the account and all server data, then signs out.
  Future<void> deleteAccount();
}

/// Used when no backend is configured: always signed out.
class OfflineAuthService implements AuthService {
  const new();

  @override
  bool get isAvailable => false;

  @override
  AppUser? get currentUser => null;

  @override
  Stream<AppUser?> get userChanges => Stream.value(null);

  @override
  Future<SignInResult> signInWithGoogle() async => SignInResult.failed;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}
}

/// Native Google sign-in (Android Credential Manager) whose ID token is
/// exchanged for a Supabase session (architecture.md 7).
class SupabaseAuthService implements AuthService {
  /// [_webClientId]: the OAuth "Web application" client ID.
  new(this._client, this._webClientId);

  final SupabaseClient _client;
  final String _webClientId;
  Future<void>? _googleReady;

  Future<void> _initGoogle() => _googleReady ??= GoogleSignIn.instance
      .initialize(serverClientId: _webClientId);

  @override
  bool get isAvailable => _webClientId.isNotEmpty;

  @override
  AppUser? get currentUser => _map(_client.auth.currentUser);

  @override
  Stream<AppUser?> get userChanges =>
      _client.auth.onAuthStateChange.map((s) => _map(s.session?.user));

  @override
  Future<SignInResult> signInWithGoogle() async {
    try {
      await _initGoogle();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) return SignInResult.failed;
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      return SignInResult.success;
    } on GoogleSignInException catch (e) {
      return e.code == GoogleSignInExceptionCode.canceled
          ? SignInResult.cancelled
          : _fail(e.code.name);
    } on AuthException catch (e) {
      return _fail('supabase ${e.statusCode}');
    } on Object catch (e) {
      return _fail(e.runtimeType.toString());
    }
  }

  /// Logs only the error kind, never tokens or the email address.
  SignInResult _fail(String kind) {
    debugPrint('Google sign-in failed: $kind');
    return SignInResult.failed;
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
    try {
      await _initGoogle();
      await GoogleSignIn.instance.signOut();
    } on Object {
      // Already signed out of Google; the Supabase session is what matters.
    }
  }

  @override
  Future<void> deleteAccount() async {
    final res = await _client.functions.invoke('delete-account');
    if (res.status != 200) {
      throw StateError('Account deletion failed (${res.status})');
    }
    await signOut();
  }

  static AppUser? _map(User? u) => u == null
      ? null
      : AppUser(
          id: u.id,
          email: u.email,
          name:
              (u.userMetadata?['full_name'] ?? u.userMetadata?['name'])
                  as String?,
          photoUrl:
              (u.userMetadata?['avatar_url'] ?? u.userMetadata?['picture'])
                  as String?,
        );
}
