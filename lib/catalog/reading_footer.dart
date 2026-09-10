import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';

/// Time-left / pace status row, pinned above the reading screen's
/// home indicator.
///
/// Takes pre-formatted label strings — no model exists yet for
/// reading-time-remaining or pace, so that computation (whatever it
/// ends up being) happens upstream of this widget.
class ReadingFooter extends StatelessWidget {
  const ReadingFooter({
    super.key,
    required this.timeLeftLabel,
    required this.paceLabel,
  });

  final String timeLeftLabel;
  final String paceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: OmoweColors.stone300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(timeLeftLabel, style: OmoweTypography.uiCaption),
          Text(
            paceLabel,
            style: OmoweTypography.uiCaption.copyWith(
              color: OmoweColors.sage600,
            ),
          ),
        ],
      ),
    );
  }
}
