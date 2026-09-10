import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'omowe_colors.dart';

/// Omowe's three type roles, each tied to the surface it runs on.
///
/// **Display** (Fraunces) — wordmark, book and chapter titles. One moment
/// of emphasis per screen; never body text.
/// **Reading** (Literata) — the book text itself. Narrow column, generous
/// line height.
/// **UI** (Inter) — nav, labels, metadata, buttons. Stays quiet; never
/// competes with content.
///
/// The web system this was ported from rides Fraunces' variable optical-size
/// axis (`opsz`). `google_fonts`'s static loader doesn't expose that axis,
/// so every display style here compensates with weight and size instead —
/// visually equivalent at the sizes this system actually uses. Restoring
/// true `opsz` interpolation would mean bundling the variable TTF directly
/// and setting `TextStyle.fontVariations` — a change scoped entirely to
/// this file.
class OmoweTypography {
  OmoweTypography._();

  /// Shared tabular-figures feature list, for the numeric contexts that
  /// need it — see [uiMicro]'s doc comment for which ones do.
  static const List<FontFeature> tabularFigures = [FontFeature.tabularFigures()];

  // ---- Display / Fraunces ----

  /// The wide masthead title. One-off use only — not a repeatable role.
  /// Letter-spacing is exact: the source's `-0.01em` at 52px is -0.52
  /// logical pixels, not a rounded -0.5.
  static TextStyle mastheadTitle = GoogleFonts.fraunces(
    fontSize: 52,
    fontWeight: FontWeight.w500,
    height: 1.08,
    letterSpacing: -0.52,
    color: OmoweColors.ink900,
  );

  /// Section headers, e.g. "Library". Letter-spacing is exact: the
  /// source's `-0.005em` at 27px is -0.135. `height: 1.2` is *not* from
  /// the source — it never sets an explicit line-height for this role —
  /// it's a deliberate, chosen default for when a heading wraps.
  static TextStyle sectionHeading = GoogleFonts.fraunces(
    fontSize: 27,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: -0.135,
    color: OmoweColors.ink900,
  );

  /// Wordmark, book, and chapter titles as they actually appear on-device.
  /// [size] should stay in the 18–24 range the system was tuned for;
  /// nothing below enforces that, so treat it as a convention. The source
  /// never sets an explicit line-height at any of the sizes this is
  /// actually used at (15.5–21px) — `height: 1.15` is a chosen default for
  /// titles that wrap to two lines, not a transcribed value.
  static TextStyle displayOnDevice({double size = 21}) => GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w500,
        height: 1.15,
        color: OmoweColors.ink900,
      );

  /// Oversized initial letter for a chapter's opening paragraph. Pair with
  /// a leading [TextSpan] in a [RichText] — Flutter has no native
  /// text-wraps-around-a-widget layout, so this sits inline rather than
  /// producing a true CSS-style float.
  static TextStyle dropCap = GoogleFonts.fraunces(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    height: 0.8,
    color: OmoweColors.ink900,
  );

  // ---- Reading / Literata ----

  /// The book text itself. Use inside a column no wider than ~60 characters
  /// — the line height here assumes that measure.
  static TextStyle readingBody = GoogleFonts.literata(
    fontSize: 16.5,
    height: 1.65,
    color: OmoweColors.ink900,
  );

  /// [readingBody], italicized. In practice every real usage so far (e.g.
  /// a chapter subtitle under a hero book title) overrides both size and
  /// color at the call site — down to 13.5px, [OmoweColors.ink500] — so
  /// treat this base style as a starting point for reading-scale emphasis,
  /// not a ready-to-use caption style.
  static TextStyle readingBodyItalic = readingBody.copyWith(
    fontStyle: FontStyle.italic,
  );

  // ---- UI / Inter ----

  /// General UI body text — anywhere [uiLabel] would feel too heavy.
  static TextStyle uiBody = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: OmoweColors.ink900,
  );

  /// Buttons, nav items, and anything else that needs to read as
  /// actionable rather than informational.
  static TextStyle uiLabel = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: OmoweColors.ink900,
  );

  /// Metadata — timestamps, counts, secondary detail under a heading. This
  /// is the size the source's own type-system page shows as its "UI
  /// caption" sample — but no concrete on-device metadata instance found
  /// so far actually uses 12.5px as-is; real usage runs 10.5–12px
  /// depending on how dense the surface is. Treat 12.5 as the loose
  /// default and check the source for the real target size before using
  /// this bare — [uiMicro] plus an explicit `fontSize` override is usually
  /// the right call for anything genuinely small or numeric.
  static TextStyle uiCaption = GoogleFonts.inter(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: OmoweColors.ink500,
  );

  /// Small standalone labels, e.g. a page kicker above a title.
  /// Letter-spacing is exact: the source's `0.02em` at 13px is 0.26.
  static TextStyle uiKicker = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: OmoweColors.ink500,
    letterSpacing: 0.26,
  );

  /// The smallest, densest metadata role: format hints, subtitle captions,
  /// and other fine print. The source varies the exact size between
  /// 10.5–12px per context — 11px is a normalized anchor, not a literal
  /// transcription; override `fontSize` per call site to match the source
  /// exactly.
  ///
  /// Not every number at this scale wants tabular figures — the source
  /// applies `font-variant-numeric: tabular-nums` to some numeric contexts
  /// (chapter numbers, percentages, progress captions, "chapters left")
  /// but not others ("4 books", "X unread"), so it isn't baked in here.
  /// Add it explicitly where the source specifies it:
  /// `uiMicro.copyWith(fontFeatures: const [FontFeature.tabularFigures()])`.
  static TextStyle uiMicro = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: OmoweColors.ink500,
  );

  /// Tag-style text above a hero element, e.g. "continue reading". Colored
  /// [OmoweColors.sage600] to read as accent rather than primary content.
  static TextStyle uiEyebrow = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: OmoweColors.sage600,
  );
}
