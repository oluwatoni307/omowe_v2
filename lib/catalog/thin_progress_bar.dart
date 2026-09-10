import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';

/// The one progress-bar treatment — reading, chapter, and transfer
/// progress alike. Pass a smaller [height] for the reading top bar's
/// mini variant; the width is controlled by whatever you place this
/// inside (a fixed-width [SizedBox], a flex child, etc.).
class ThinProgressBar extends StatelessWidget {
  const ThinProgressBar({super.key, required this.value, this.height = 2});

  /// 0.0–1.0.
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: OmoweColors.stone300,
          valueColor: const AlwaysStoppedAnimation<Color>(OmoweColors.sage400),
        ),
      ),
    );
  }
}
