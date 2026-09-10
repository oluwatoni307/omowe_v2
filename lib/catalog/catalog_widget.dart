import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';

/// One labeled example inside the widget catalog.
///
/// The bordered box isolates the widget's own bounds from the
/// surrounding layout, so you can tell "no background" from
/// "invisible" — and every entry gets a caption naming exactly what
/// state it's demonstrating.
class CatalogEntry extends StatelessWidget {
  const CatalogEntry({
    super.key,
    required this.label,
    required this.child,
    this.width,
  });

  final String label;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: OmoweTypography.uiCaption),
        const SizedBox(height: 6),
        Container(
          width: width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: OmoweColors.stone300),
            color: OmoweColors.stone50,
          ),
          child: child,
        ),
      ],
    );
  }
}

/// A titled group of [CatalogEntry] examples.
class CatalogSection extends StatelessWidget {
  const CatalogSection({super.key, required this.title, required this.entries});

  final String title;
  final List<Widget> entries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: OmoweTypography.sectionHeading),
          const SizedBox(height: 16),
          Wrap(spacing: 16, runSpacing: 16, children: entries),
        ],
      ),
    );
  }
}
