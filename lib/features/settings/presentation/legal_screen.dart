import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// Renders the bundled privacy policy / terms (a tiny Markdown subset:
/// `#`/`##` headings, `- ` bullets, `**bold**` lead-ins, paragraphs).
class LegalScreen extends StatelessWidget {
  const new({required this.doc, super.key});

  /// `privacy` or `terms`.
  final String doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/legal/$doc.md'),
        builder: (context, snap) {
          final text = snap.data;
          if (text == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [for (final block in _blocks(text)) block(context)],
          );
        },
      ),
    );
  }

  static List<Widget Function(BuildContext)> _blocks(String md) => [
    for (final line in md.split('\n'))
      if (line.trim().isNotEmpty) (context) => _line(context, line.trim()),
  ];

  static Widget _line(BuildContext context, String line) {
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    if (line.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Semantics(
          header: true,
          child: Text(line.substring(2), style: text.titleLarge),
        ),
      );
    }
    if (line.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xl,
          bottom: AppSpacing.sm,
        ),
        child: Semantics(
          header: true,
          child: Text(line.substring(3), style: text.headlineSmall),
        ),
      );
    }
    final bullet = line.startsWith('- ');
    final body = bullet ? line.substring(2) : line;
    final paragraph = Text.rich(
      _inline(body, text.bodyLarge?.copyWith(height: 1.5)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: bullet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•  ',
                  style: text.bodyLarge?.copyWith(color: c.textSecondary),
                ),
                Expanded(child: paragraph),
              ],
            )
          : paragraph,
    );
  }

  /// `**bold**` segments.
  static TextSpan _inline(String s, TextStyle? style) {
    final parts = s.split('**');
    return TextSpan(
      style: style,
      children: [
        for (final (i, p) in parts.indexed)
          TextSpan(
            text: p,
            style: i.isOdd
                ? const TextStyle(fontWeight: FontWeight.w700)
                : null,
          ),
      ],
    );
  }
}
