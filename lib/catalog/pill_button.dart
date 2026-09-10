import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_shapes.dart';
import '../theme/omowe_typography.dart';

enum OmowePillVariant { sage, ink }

/// The general pill button — `.sage` or `.ink` fill.
///
/// Sage is reserved for the resume/continue-reading action
/// specifically — use [ResumePillButton] for that instead. Any other
/// primary pill (e.g. "Choose file") is
/// `OmowePillButton(variant: OmowePillVariant.ink, ...)`.
class OmowePillButton extends StatelessWidget {
  const OmowePillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = OmowePillVariant.ink,
    this.icon,
    this.compact = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final OmowePillVariant variant;
  final IconData? icon;
  final bool compact;
  final bool expand;

  Color get _fill => variant == OmowePillVariant.sage
      ? OmoweColors.sage700
      : OmoweColors.ink900;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: _fill,
      shape: OmoweShapes.pillShape,
      child: InkWell(
        customBorder: OmoweShapes.pillShape,
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 14 : 18,
            vertical: compact ? 9 : 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: OmoweTypography.uiLabel.copyWith(
                  color: OmoweColors.stone50,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 6),
                Icon(icon, size: 13, color: OmoweColors.stone50),
              ],
            ],
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
