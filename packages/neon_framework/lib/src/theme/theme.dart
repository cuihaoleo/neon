import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/theme/colors.dart';
import 'package:neon_framework/src/theme/neon.dart';
import 'package:neon_framework/src/utils/hex_color.dart';
import 'package:nextcloud/core.dart' as core;

/// Custom theme used for the Neon app.
@internal
@immutable
class AppTheme {
  /// Creates a new Neon app theme.
  const AppTheme({
    required this.nextcloudTheme,
    required this.deviceThemeLight,
    required this.deviceThemeDark,
    required this.neonTheme,
    final bool useNextcloudTheme = false,
    this.oledAsDark = false,
    this.appThemes,
  }) : useNextcloudTheme = nextcloudTheme == null || useNextcloudTheme;

  /// The theme provided by the Nextcloud server.
  final core.ThemingPublicCapabilities_Theming? nextcloudTheme;

  /// Whether to use of the Nextcloud theme.
  final bool useNextcloudTheme;

  /// The light theme provided by the device.
  final ColorScheme? deviceThemeLight;

  /// The dark theme provided by the device.
  final ColorScheme? deviceThemeDark;

  /// Whether to use [NcColors.oledBackground] in the dark theme.
  final bool oledAsDark;

  /// The theme extensions provided by the `AppImplementation`s.
  final Iterable<ThemeExtension>? appThemes;

  /// The base theme for the Neon app.
  final NeonTheme neonTheme;

  ColorScheme _buildColorScheme(final Brightness brightness) {
    ColorScheme? colorScheme;

    if (nextcloudTheme != null && useNextcloudTheme) {
      final primaryColor = HexColor(nextcloudTheme!.color);
      final onPrimaryColor = HexColor(nextcloudTheme!.colorText);

      colorScheme = ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
      ).copyWith(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: primaryColor,
        onSecondary: onPrimaryColor,
        tertiary: primaryColor,
        onTertiary: onPrimaryColor,
      );
    } else {
      colorScheme = brightness == Brightness.dark ? deviceThemeDark : deviceThemeLight;
    }

    colorScheme ??= ColorScheme.fromSeed(
      seedColor: NcColors.primary,
      brightness: brightness,
    );

    if (oledAsDark && brightness == Brightness.dark) {
      colorScheme = colorScheme.copyWith(
        background: NcColors.oledBackground,
      );
    }

    return colorScheme;
  }

  ThemeData _getTheme(final Brightness brightness) {
    final colorScheme = _buildColorScheme(brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.background,
      // For LicensePage
      snackBarTheme: _snackBarTheme,
      dividerTheme: _dividerTheme,
      scrollbarTheme: _scrollbarTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        textTheme: const CupertinoTextThemeData(),
      ),
      extensions: [
        neonTheme,
        ...?appThemes,
      ],
    );
  }

  /// Returns a new theme for [Brightness.light].
  ///
  /// Used in [MaterialApp.theme].
  ThemeData get lightTheme => _getTheme(Brightness.light);

  /// Returns a new theme for [Brightness.dark].
  ///
  /// Used in [MaterialApp.darkTheme].
  ThemeData get darkTheme => _getTheme(Brightness.dark);

  static const _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  );

  static const _dividerTheme = DividerThemeData(
    thickness: 1.5,
    space: 30,
  );

  static const _scrollbarTheme = ScrollbarThemeData(
    interactive: true,
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );
}
