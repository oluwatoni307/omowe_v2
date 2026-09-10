import 'package:flutter/material.dart';

import 'pill_button.dart';

/// Preset of [OmowePillButton] for resume/continue-reading
/// specifically — sage fill, arrow icon.
///
/// Rule: one [ResumePillButton] per screen, max.
class ResumePillButton extends StatelessWidget {
  const ResumePillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Inline use (e.g. beside text in a hero row) vs. full-width
  /// standalone.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return OmowePillButton(
      label: label,
      onPressed: onPressed,
      variant: OmowePillVariant.sage,
      icon: Icons.arrow_forward,
      compact: compact,
      expand: !compact,
    );
  }
}
