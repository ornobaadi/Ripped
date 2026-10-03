import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/l10n/l10n.dart';

/// Three tabs. That's it (design.md 2). The nav bar floats over the tab
/// content, which scrolls behind it.
class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: shell.currentIndex,
        onSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          FloatingNavDestination(
            icon: Symbols.exercise_rounded,
            label: l10n.tabToday,
          ),
          FloatingNavDestination(
            icon: Symbols.monitoring_rounded,
            label: l10n.tabProgress,
          ),
          FloatingNavDestination(
            icon: Symbols.person_rounded,
            label: l10n.tabYou,
          ),
        ],
      ),
    );
  }
}
