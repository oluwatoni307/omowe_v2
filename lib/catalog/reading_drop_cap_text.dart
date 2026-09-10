import 'package:flutter/material.dart';
import '../theme/omowe_typography.dart';

/// A chapter's opening paragraph, with a large first letter set beside
/// the following text — the effect [OmoweTypography.dropCap] exists
/// for.
///
/// Flutter has no native CSS `::first-letter` float layout, so this
/// is an approximation, not a pixel match: the drop cap is an inline
/// [WidgetSpan] at the start of the [RichText]. That grows the first
/// line's height around the glyph, but doesn't wrap the *second* and
/// *third* lines around it the way the source mockup's CSS float
/// does. Revisit with a custom [RenderObject] if a true multi-line
/// wrap is ever required.
class ReadingDropCapText extends StatelessWidget {
  const ReadingDropCapText({super.key, required this.paragraph});

  final String paragraph;

  @override
  Widget build(BuildContext context) {
    if (paragraph.isEmpty) return const SizedBox.shrink();

    // Simple substring split — fine for Latin-script prose. Swap for
    // `paragraph.characters.first` (package:characters, ships with
    // Flutter) if this ever needs to handle multi-byte grapheme
    // clusters correctly (emoji, combining marks, some non-Latin
    // scripts).
    final firstLetter = paragraph.substring(0, 1);
    final rest = paragraph.substring(1);

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Padding(
              padding: const EdgeInsets.only(right: 2, top: 4),
              child: Text(firstLetter, style: OmoweTypography.dropCap),
            ),
          ),
          TextSpan(text: rest, style: OmoweTypography.readingBody),
        ],
      ),
    );
  }
}
