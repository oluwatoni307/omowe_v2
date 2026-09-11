import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_shapes.dart';
import '../theme/omowe_typography.dart';
import 'resume_pill_button.dart';

/// Tinted hero card on the Library screen — the one place tint is
/// allowed outside a cover, since it's actively showing that book.
///
/// Takes plain values, not a model: whoever composes the Library
/// screen is responsible for pulling `bookTitle` / `chunkTitle` /
/// `chunksLeft` out of `ContinueReadingInfo` first.
class ContinueReadingHero extends StatelessWidget {
  const ContinueReadingHero({
    super.key,
    required this.bookTitle,
    required this.chunkTitle,
    required this.chunksLeft,
    required this.onResume,
    this.onTap,
    this.tintIndex = 0,
  });

  final String bookTitle;
  final String chunkTitle;
  final int chunksLeft;
  final VoidCallback onResume;
  final VoidCallback? onTap;

  /// Should match this book's assigned cover tint elsewhere in the
  /// library — this card is "showing that same book," not a neutral.
  final int tintIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: OmoweShapes.cardRadius,
        child: Container(
          padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
          decoration: ShapeDecoration(
            color: OmoweColors.sageWash,
            shape: OmoweShapes.cardShape.copyWith(
              side: const BorderSide(color: OmoweColors.sage400),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('continue reading', style: OmoweTypography.uiEyebrow),
              const SizedBox(height: 8),
              Text(bookTitle, style: OmoweTypography.displayOnDevice(size: 21)),
              const SizedBox(height: 3),
              Text(
                chunkTitle,
                style: OmoweTypography.readingBodyItalic.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$chunksLeft chapters left',
                    style: OmoweTypography.uiBody.copyWith(
                      fontFeatures: OmoweTypography.tabularFigures,
                    ),
                  ),
                  ResumePillButton(
                    label: 'Resume reading',
                    onPressed: onResume,
                    compact: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
