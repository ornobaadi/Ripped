import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/l10n/l10n.dart';

/// Searchable list of exercises the user has equipment for.
Future<String?> showAddExerciseSheet(BuildContext context, WidgetRef ref) {
  final profile = ref.read(profileProvider);
  final options =
      ref
          .read(catalogProvider)
          .all
          .where((e) => hasAccess(profile.equipment, e.equipment))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  return showAppSheet<String>(
    context,
    scrollable: true,
    builder: (_) => _AddExerciseList(options: options),
  );
}

class _AddExerciseList extends StatefulWidget {
  const new({required this.options});

  final List<Exercise> options;

  @override
  State<_AddExerciseList> createState() => _AddExerciseListState();
}

class _AddExerciseListState extends State<_AddExerciseList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.options
        : widget.options
              .where(
                (e) =>
                    e.name.toLowerCase().contains(q) ||
                    e.primaryMuscles.any((m) => m.contains(q)),
              )
              .toList();
    final c = context.colors;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: context.l10n.searchExercises,
              prefixIcon: const Icon(Symbols.search_rounded),
              filled: true,
              fillColor: c.surfaceRaised,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.card),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemExtent: 64,
              itemBuilder: (context, i) {
                final e = filtered[i];
                return InkWell(
                  onTap: () => Navigator.pop(context, e.id),
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                  child: Row(
                    children: [
                      ExerciseThumb(exercise: e, size: 48),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              e.primaryMuscles.join(', '),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: c.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
