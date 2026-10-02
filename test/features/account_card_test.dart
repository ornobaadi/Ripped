import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/auth/auth_service.dart';
import 'package:ripped/features/settings/presentation/account_card.dart';

import '../helpers/golden.dart';

class FakeAuth implements AuthService {
  new({this.result = SignInResult.success, this.available = true});

  final SignInResult result;
  final bool available;
  final _users = StreamController<AppUser?>.broadcast();
  AppUser? _user;
  int signOuts = 0;

  @override
  bool get isAvailable => available;

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> get userChanges => _users.stream;

  @override
  Future<SignInResult> signInWithGoogle() async {
    if (result == SignInResult.success) {
      _user = const AppUser(
        id: 'u1',
        email: 'lifter@example.com',
        name: 'Alex Lifter',
      );
      _users.add(_user);
    }
    return result;
  }

  int deletions = 0;

  @override
  Future<void> deleteAccount() async {
    deletions++;
    await signOut();
  }

  @override
  Future<void> signOut() async {
    signOuts++;
    _user = null;
    _users.add(null);
  }
}

void main() {
  Future<void> pump(WidgetTester tester, AuthService auth) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(auth)],
        child: wrapForTest(const AccountCard()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hidden when no backend is configured', (tester) async {
    await pump(tester, const OfflineAuthService());
    expect(find.text('Continue with Google'), findsNothing);
  });

  testWidgets('sign in, then sign out', (tester) async {
    final auth = FakeAuth();
    await pump(tester, auth);
    expect(find.text('Back up your progress'), findsOneWidget);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.text('Alex Lifter'), findsOneWidget);
    expect(find.text('lifter@example.com'), findsOneWidget);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out').last);
    await tester.pumpAndSettle();
    expect(auth.signOuts, 1);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('cancelling stays quiet; failing explains', (tester) async {
    await pump(tester, FakeAuth(result: SignInResult.cancelled));
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);

    await pump(tester, FakeAuth(result: SignInResult.failed));
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
