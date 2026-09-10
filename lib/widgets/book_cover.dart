import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';
import '../theme/omowe_shapes.dart';

/// A book cover — the one place in Omowe allowed to carry color, because it
/// represents a physical object, not chrome. [tintIndex] cycles through the
/// four content tints; never reuse these colors for UI elements.
class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.title, required this.tintIndex});

  final String title;
  final int tintIndex;

  @override
  Widget build(BuildContext context) {
    final (bg, border) =
        OmoweColors.coverTints[tintIndex % OmoweColors.coverTints.length];
    return AspectRatio(
      aspectRatio: 6 / 7,
      child: Container(
        padding: const EdgeInsets.all(11),
        alignment: Alignment.bottomLeft,
        decoration: ShapeDecoration(
          color: bg,
          shape: OmoweShapes.cardShape.copyWith(
            side: BorderSide(color: border),
          ),
        ),
        child: Text(
          title,
          style: OmoweTypography.displayOnDevice(
            size: 13.5,
          ).copyWith(height: 1.22),
        ),
      ),
    );
  }
}
