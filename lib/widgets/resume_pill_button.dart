import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';
import '../theme/omowe_shapes.dart';
import '../theme/omowe_motion.dart';

/// The one action worth finding by touch alone — full pill, solid sage-700
/// fill, stone-50 text (4.9:1 contrast). A washed, translucent version of
/// this button was tried and rejected: it read as decorative and failed
/// contrast outright. This is Omowe's only "loud" surface; everything else
/// stays neutral plus sage.
class ResumePillButton extends StatelessWidget {
  const ResumePillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OmoweColors.sage700,
      shape: OmoweShapes.pillShape,
      child: InkWell(
        customBorder: OmoweShapes.pillShape,
        onTap: onPressed,
        child: AnimatedContainer(
          duration: OmoweMotion.quick,
          curve: OmoweMotion.easeTouch,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 14 : 18,
            vertical: compact ? 8 : 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: OmoweTypography.uiLabel.copyWith(
                  color: OmoweColors.stone50,
                  fontSize: compact ? 13 : 14,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward, size: 13, color: OmoweColors.stone50),
            ],
          ),
        ),
      ),
    );
  }
}
