import 'package:flutter/material.dart';
import 'omowe_colors.dart'; // referenced only in doc comments, for dartdoc cross-links

/// Radius tokens: sharp where structure matters, soft where touch matters,
/// full pill only for the one action worth finding by feel alone.
///
/// Elevation is a rule this class encodes but doesn't give a token for:
/// inside the app, depth is a hairline ([OmoweColors.stone300]) or a
/// tone-step ([OmoweColors.stone50] → [OmoweColors.paper100]) — never a box
/// shadow. A soft shadow is reserved for grounding a device mockup on a
/// page in marketing or illustration contexts; it never appears on an app
/// screen itself.
class OmoweShapes {
  OmoweShapes._();

  /// List rows and dividers — structure should feel exact, not soft.
  static const double radiusFlat = 0;

  /// The corner radius [cardShape] is built from. Covers and hero panels.
  static const double radiusCard = 10;

  /// Full pill radius, reserved for [pillShape].
  static const double radiusPill = 999;

  /// [radiusCard] as a [BorderRadius], for APIs that take one directly
  /// (e.g. [ClipRRect]) rather than a full [ShapeBorder].
  static const BorderRadius cardRadius =
      BorderRadius.all(Radius.circular(radiusCard));

  /// Shape for the one primary action per screen — full pill, found by
  /// touch alone. Used by `ResumePillButton`.
  static const ShapeBorder pillShape = StadiumBorder();

  /// Shape for card surfaces: a rounded superellipse ("squircle") rather
  /// than a plain circular radius — a smoother, more continuous curve at
  /// the same corner radius. Landed in Flutter stable 3.32 (May 2025).
  ///
  /// This is a [ShapeBorder], not a [BorderRadius] — pair it with
  /// [ShapeDecoration], not [BoxDecoration]. Border color varies per
  /// surface (hairline [OmoweColors.stone300] vs. a cover's tint border),
  /// so apply it with `.copyWith(side: ...)` at each call site rather than
  /// baking a color in here. Falls back to a plain rounded rect on web
  /// builds before Flutter 3.38.3 — current stable is well past that.
  static const RoundedSuperellipseBorder cardShape =
      RoundedSuperellipseBorder(borderRadius: cardRadius);
}
