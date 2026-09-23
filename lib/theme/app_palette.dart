import 'package:flutter/material.dart';

import 'colour/appbackground_theme.dart';
import 'colour/appborder_theme.dart';
import 'colour/appfield_theme.dart';
import 'colour/applayer_theme.dart';
import 'colour/applayeraccent_theme.dart';
import 'colour/applink_theme.dart';
import 'colour/appsupport_theme.dart';
import 'colour/apptext_theme.dart';
import 'typography/app_typography.dart';

/// Resolved design-token palette for the current [Brightness].
///
/// Everything the UI renders reads from [ZoaPalette] — via
/// `context.palette` — instead of reaching into individual token files. Picking
/// a semantic role here (surface, border, textPrimary, …) keeps component code
/// readable and guarantees the light/dark split stays consistent app-wide.
class ZoaPalette {
  const ZoaPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnColor,
    required this.border,
    required this.borderSubtle,
    required this.borderStrong,
    required this.error,
    required this.success,
    required this.link,
    required this.field,
  });

  final Color background;

  /// Raised surfaces — cards, sheets, panels.
  final Color surface;

  /// Quiet muted background behind fields and secondary blocks.
  final Color surfaceMuted;

  /// Wash used for chips, pills and highlighted rows.
  final Color accent;

  final Color textPrimary;

  final Color textSecondary;

  final Color textOnColor;

  final Color border;

  final Color borderSubtle;

  final Color borderStrong;

  final Color error;

  final Color success;

  final Color link;

  /// Text-field fill.
  final Color field;

  static ZoaPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark() : light();

  static ZoaPalette light() => const ZoaPalette(
        background: AppBackgroundColors.lightBackground,
        surface: AppLayerColors.lightStyle01,
        surfaceMuted: AppBackgroundColors.lightSurfaceMuted,
        accent: AppLayerAccentColors.lightAccent01,
        textPrimary: AppTextColors.whiteTextPrimary,
        textSecondary: AppTextColors.whiteTextSecondary,
        textOnColor: AppTextColors.whiteTextOnColor,
        border: AppBorderColors.lightBorderSubtle01,
        borderSubtle: AppBorderColors.lightBorderSubtle00,
        borderStrong: AppBorderColors.lightBorderStrong01,
        error: AppSupportColors.lightError,
        success: AppSupportColors.lightSuccess,
        link: AppLinkColors.whiteLinkPrimary,
        field: AppLayerColors.lightStyle01,
      );

  static ZoaPalette dark() => const ZoaPalette(
        background: AppBackgroundColors.darkBackground,
        surface: AppLayerColors.gray100Style01,
        surfaceMuted: AppBackgroundColors.darkSurfaceMuted,
        accent: AppLayerAccentColors.gray100Accent01,
        textPrimary: AppTextColors.gray100TextPrimary,
        textSecondary: AppTextColors.gray100TextSecondary,
        textOnColor: AppTextColors.gray100TextOnColor,
        border: AppBorderColors.gray100BorderSubtle01,
        borderSubtle: AppBorderColors.gray100BorderSubtle00,
        borderStrong: AppBorderColors.gray100BorderStrong01,
        error: AppSupportColors.darkError,
        success: AppSupportColors.darkSuccess,
        link: AppLinkColors.gray100LinkPrimary,
        field: AppFieldColors.gray100Field02,
      );
}

/// Extension giving every widget a `context.palette`.
extension PaletteContext on BuildContext {
  ZoaPalette get palette => ZoaPalette.of(this);

  /// Non-null resolved text roles from the active [ThemeData].
  ///
  /// `Theme.of(context).textTheme` slots are nullable in the API; these
  /// accessors normalise to a concrete style so widgets can call `.copyWith`
  /// without null-checks.
  ZoaText get appText => ZoaText.of(Theme.of(this).textTheme);
}

/// Non-null type roles derived from the theme's [TextTheme].
///
/// Mirrors the roles the components previously used (`h2`, `body`, `label`…)
/// onto the Material slots configured by the design system, keeping call sites
/// readable.
class ZoaText {
  const ZoaText._(this._t);

  final TextTheme _t;

  static ZoaText of(TextTheme t) => ZoaText._(t);

  TextStyle get display => _t.displaySmall ?? _t.headlineMedium!;
  TextStyle get hero => _t.headlineLarge ?? _t.headlineMedium!;
  TextStyle get h1 => _t.headlineLarge ?? _t.headlineMedium!;
  TextStyle get h2 => _t.headlineMedium ?? _t.titleLarge!;
  TextStyle get h3 => _t.headlineSmall ?? _t.titleMedium!;
  TextStyle get cardTitle => _t.titleMedium ?? _t.titleSmall!;
  TextStyle get title => _t.titleMedium ?? _t.titleSmall!;
  TextStyle get statNum => _t.headlineMedium ?? _t.titleLarge!;
  TextStyle get pointsHero => _t.displayMedium ?? _t.headlineLarge!;
  TextStyle get lead => _t.bodyLarge ?? _t.bodyMedium!;
  TextStyle get body => _t.bodyMedium ?? _t.bodyLarge!;
  TextStyle get bodySoft => _t.bodySmall ?? _t.bodyMedium!;
  TextStyle get bodySm => _t.bodySmall ?? _t.bodyMedium!;
  TextStyle get label => _t.labelLarge ?? _t.labelMedium!;
  TextStyle get button => _t.labelLarge ?? _t.labelMedium!;
  TextStyle get kicker => _t.labelSmall ?? _t.labelMedium!;
  TextStyle get eyebrow => _t.labelSmall ?? _t.labelMedium!;
  /// Monospace body: codes, ids, anything read character by character.
  TextStyle get mono => (_t.bodyMedium ?? _t.bodyLarge!)
      .copyWith(fontFamily: AppTypography.monoFontFamily);
  TextStyle get tag => _t.labelSmall ?? _t.labelMedium!;
  TextStyle get pointsCost => _t.labelMedium ?? _t.titleSmall!;
  TextStyle get code => _t.headlineMedium ?? _t.titleLarge!;

  // Material slot names, exposed non-null so call sites can `.copyWith`
  // without null-checks.
  TextStyle get bodySmall => _t.bodySmall ?? _t.bodyMedium!;
  TextStyle get bodyMedium => _t.bodyMedium ?? _t.bodyLarge!;
  TextStyle get bodyLarge => _t.bodyLarge ?? _t.bodyMedium!;
  TextStyle get labelLarge => _t.labelLarge ?? _t.labelMedium!;
  TextStyle get labelMedium => _t.labelMedium ?? _t.labelSmall!;
  TextStyle get labelSmall => _t.labelSmall ?? _t.labelMedium!;
  TextStyle get headlineLarge => _t.headlineLarge ?? _t.headlineMedium!;
  TextStyle get headlineMedium => _t.headlineMedium ?? _t.headlineLarge!;
  TextStyle get headlineSmall => _t.headlineSmall ?? _t.titleLarge!;
  TextStyle get titleMedium => _t.titleMedium ?? _t.titleSmall!;
  TextStyle get titleLarge => _t.titleLarge ?? _t.headlineSmall!;
  TextStyle get titleSmall => _t.titleSmall ?? _t.titleMedium!;
  TextStyle get displaySmall => _t.displaySmall ?? _t.headlineLarge!;
  TextStyle get displayMedium => _t.displayMedium ?? _t.displaySmall!;
  TextStyle get displayLarge => _t.displayLarge ?? _t.displayMedium!;
}
