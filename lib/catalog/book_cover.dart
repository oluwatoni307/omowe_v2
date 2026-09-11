import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_shapes.dart';
import '../theme/omowe_typography.dart';

/// Title + tint, 6:7 squircle.
///
/// Rule: tint touches nothing but a cover — never chrome.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.title,
    required this.tintIndex,
    this.showTitle = true,
  });

  final String title;
  final int tintIndex;

  /// Library grid covers show the title overlaid; a cover used
  /// beside a title that's already rendered as text (e.g. the book
  /// header) doesn't need it.
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final (bg, border) =
        OmoweColors.coverTints[tintIndex % OmoweColors.coverTints.length];

    return AspectRatio(
      aspectRatio: 2.35 / 1,
      child: Container(
        decoration: ShapeDecoration(
          color: bg,
          shape: OmoweShapes.cardShape.copyWith(
            side: BorderSide(color: border),
          ),
        ),
        padding: const EdgeInsets.all(11),
        alignment: Alignment.bottomLeft,
        child: showTitle
            ? Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: OmoweTypography.displayOnDevice(size: 16),
              )
            : null,
      ),
    );
  }
}
