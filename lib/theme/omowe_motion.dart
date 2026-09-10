import 'package:flutter/animation.dart';

/// Two eases, three durations. Nothing in Omowe animates past
/// [deliberate].
class OmoweMotion {
  OmoweMotion._();

  /// Untouched state changes: progress, pacing, chapter transitions.
  ///
  /// `cubic-bezier(0.4,0,0.2,1)` — Flutter exposes this exact cubic as
  /// [Curves.fastOutSlowIn]. Current Flutter's own docs label it
  /// `Easing.legacy` (the Material 2 curve; Material 3's `Easing.standard`
  /// is a different, multi-segment curve). Kept as `fastOutSlowIn`
  /// deliberately, to match the source design system's literal
  /// cubic-bezier value rather than drift toward Material 3's default feel.
  static const Curve easeRead = Curves.fastOutSlowIn;

  /// Direct taps: buttons, cover press.
  static const Curve easeTouch = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Shortest duration in the system — reserved for state changes with no
  /// perceptible motion, just a value flip.
  static const Duration instant = Duration(milliseconds: 100);

  /// Default duration for direct-manipulation feedback (button press,
  /// tap states). Pairs with [easeTouch].
  static const Duration quick = Duration(milliseconds: 220);

  /// Longest duration in the system — chapter transitions and other
  /// untouched state changes. Pairs with [easeRead]. Nothing should exceed
  /// this; if a transition needs to run longer, it's the wrong transition.
  static const Duration deliberate = Duration(milliseconds: 420);

  /// In the signature chapter-reveal cadence, the flat delay before the
  /// title appears (the source's `h4 { animation-delay: 40ms }`,
  /// measured from the eyebrow at 0ms — not scaled by position).
  static const Duration titleLead = Duration(milliseconds: 40);

  /// In the signature chapter-reveal cadence, the step between body
  /// lines — the source's one visible line sits at 80ms
  /// (`p { animation-delay: 80ms }`), which is [lineStagger] × 1, counted
  /// independently from [titleLead] rather than added on top of it. A
  /// second line would sit at [lineStagger] × 2, and so on.
  static const Duration lineStagger = Duration(milliseconds: 80);
}
