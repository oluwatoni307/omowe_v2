import 'package:flutter/material.dart';
import 'omowe_colors.dart';
import 'omowe_typography.dart';
import 'omowe_shapes.dart';

/// Assembles [OmoweColors], [OmoweTypography], and [OmoweShapes] into a
/// single [ThemeData]. Elevation is deliberately zeroed everywhere here —
/// see [OmoweShapes]'s doc comment for the rule this encodes: hairline or
/// tone-step inside the app, shadow only outside it.
class OmoweTheme {
  OmoweTheme._();

  /// The (only, currently) Omowe theme. Material 3 has been Flutter's
  /// default since 3.16, so there's no `useMaterial3` flag to set — current
  /// Flutter is actively removing that flag from example code as cruft.
  ///
  /// Pass this to [MaterialApp.theme]:
  /// ```dart
  /// MaterialApp(theme: OmoweTheme.light, home: const YourScreen());
  /// ```
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: OmoweColors.stone50,
      colorScheme: ColorScheme.fromSeed(
        seedColor: OmoweColors.sage600,
        brightness: Brightness.light,
        primary: OmoweColors.sage700,
        onPrimary: OmoweColors.stone50,
        surface: OmoweColors.stone50,
        onSurface: OmoweColors.ink900,
      ),
      textTheme: TextTheme(
        headlineLarge: OmoweTypography.mastheadTitle,
        headlineMedium: OmoweTypography.sectionHeading,
        bodyLarge: OmoweTypography.readingBody,
        bodyMedium: OmoweTypography.uiBody,
        labelLarge: OmoweTypography.uiLabel,
        labelSmall: OmoweTypography.uiCaption,
      ),
      dividerTheme: const DividerThemeData(
        color: OmoweColors.stone300,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: OmoweColors.paper100,
        elevation: 0,
        shape: OmoweShapes.cardShape
            .copyWith(side: const BorderSide(color: OmoweColors.stone300)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OmoweColors.sage700,
          foregroundColor: OmoweColors.stone50,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: OmoweTypography.uiLabel.copyWith(color: OmoweColors.stone50),
          padding: const EdgeInsets.fromLTRB(20, 10, 18, 10),
        ),
      ),
      dividerColor: OmoweColors.stone300,
      splashFactory: NoSplash.splashFactory,
    );
  }
}
