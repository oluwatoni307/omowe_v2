import 'package:flutter/material.dart';
import '../theme/omowe_typography.dart';

/// Section label + optional trailing meta (a count, a status string).
///
/// Used for "Library / 4 books" and "Recently added". Neither the
/// label nor the trailing text gets tabular figures — matches the
/// source spec exactly ("4 books", "X unread" are not tabular
/// contexts).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.label, this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(label, style: OmoweTypography.uiLabel.copyWith(fontSize: 16)),
        if (trailing != null)
          Text(
            trailing!,
            style: OmoweTypography.uiCaption.copyWith(fontSize: 13),
          ),
      ],
    );
  }
}
