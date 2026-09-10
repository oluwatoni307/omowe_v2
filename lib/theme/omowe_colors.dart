import 'package:flutter/material.dart';

/// Omowe's color tokens: a neutral base, one functional accent, and one
/// bounded exception.
///
/// Chrome — buttons, nav, progress, list rows — is always neutral plus
/// [sage400], [sage600], or [sage700]. It never uses a cover tint. The only
/// exception is content itself: a book cover, or a hero card actively
/// displaying that same book, may carry color no other surface does.
class OmoweColors {
  OmoweColors._();

  // ---- Neutrals ----

  /// Page background.
  static const Color stone50 = Color(0xFFF6F5F3);

  /// Card and cover surface, one step up from [stone50].
  static const Color paper100 = Color(0xFFEFEDE8);

  /// Hairline borders and dividers. The system's only depth cue — see
  /// [OmoweShapes] for the no-shadow rule this supports.
  static const Color stone300 = Color(0xFFD8D4CC);

  /// Secondary text — captions, metadata, anything not the primary read.
  static const Color ink500 = Color(0xFF5B6669);

  /// Primary text color for both UI and reading content.
  static const Color ink900 = Color(0xFF242B2E);

  // ---- Accent — sage, functional only ----

  /// Progress fills and informational accents. Not for text — contrast
  /// against [stone50] isn't sufficient at body-text weights.
  static const Color sage400 = Color(0xFF8FA398);

  /// Section labels, eyebrows, and other small functional text that needs
  /// to read as "accent" rather than primary content.
  static const Color sage600 = Color(0xFF6E8377);

  /// The one sage step dark enough to carry text on a solid fill —
  /// ~5.4:1 contrast against [stone50]. Used by [ResumePillButton] and
  /// nothing else; a washed/translucent version of that button was tried
  /// and rejected for failing contrast outright.
  static const Color sage700 = Color(0xFF56695E);

  /// [sage400] at 15% alpha — matches the source's own named
  /// `--sage-wash` custom property exactly (`rgba(143,163,152,0.15)`,
  /// where 143/163/152 is sage400's RGB). Used to highlight the current
  /// chapter row. Kept as a computed value rather than a baked ARGB
  /// literal, since baking would round 0.15 to an 8-bit alpha byte and
  /// lose precision that `withValues` preserves.
  static Color get sageWash => sage400.withValues(alpha: 0.15);

  // ---- Content exception — book cover tints. Never used for chrome/UI. ----

  /// Cover background, blue tint.
  static const Color tintBlueBg = Color(0xFFE1E8EA);

  /// Cover border, blue tint.
  static const Color tintBlueBd = Color(0xFFC7D5D8);

  /// Cover background, clay tint.
  static const Color tintClayBg = Color(0xFFF1E3D9);

  /// Cover border, clay tint.
  static const Color tintClayBd = Color(0xFFE0C9B6);

  /// Cover background, ochre tint.
  static const Color tintOchreBg = Color(0xFFF2E9D6);

  /// Cover border, ochre tint.
  static const Color tintOchreBd = Color(0xFFE1D1AC);

  /// Cover background, plum tint.
  static const Color tintPlumBg = Color(0xFFEBE0E6);

  /// Cover border, plum tint.
  static const Color tintPlumBd = Color(0xFFD6C3CE);

  /// The four cover tints as `(background, border)` pairs, in display
  /// order. Index into this with a book's position (`i % coverTints.length`)
  /// rather than referencing an individual tint field directly — that's
  /// what keeps new covers cycling instead of clustering on one color.
  static const List<(Color bg, Color border)> coverTints = [
    (tintBlueBg, tintBlueBd),
    (tintClayBg, tintClayBd),
    (tintOchreBg, tintOchreBd),
    (tintPlumBg, tintPlumBd),
  ];
}
