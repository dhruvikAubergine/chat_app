import 'package:flutter/material.dart';

abstract class AppTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff7C7B9B),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE0E0FF),
    onPrimaryContainer: Color(0xFF000569),
    secondary: Color(0xFF5C5D72),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE1E0F9),
    onSecondaryContainer: Color(0xFF191A2C),
    tertiary: Color(0xFF78536B),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD7EE),
    onTertiaryContainer: Color(0xFF2E1126),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF1B1B1F),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1B1B1F),
    surfaceVariant: Color(0xFFE3E1EC),
    onSurfaceVariant: Color(0xFF46464F),
    outline: Color(0xFF777680),
    onInverseSurface: Color(0xFFF3F0F4),
    inverseSurface: Color(0xFF303034),
    inversePrimary: Color(0xFFBEC2FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF3946EA),
  );

  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    final scheme = lightColorScheme ??
        AppTheme.lightColorScheme.copyWith(secondary: const Color(0xffFCAAAB));
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xff7C7B9B),
      colorScheme: scheme,
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    final scheme = darkColorScheme ?? AppTheme.darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBEC2FF),
    onPrimary: Color(0xFF000CA5),
    primaryContainer: Color(0xFF1725D4),
    onPrimaryContainer: Color(0xFFE0E0FF),
    secondary: Color(0xFFC5C4DD),
    onSecondary: Color(0xFF2E2F42),
    secondaryContainer: Color(0xFF444559),
    onSecondaryContainer: Color(0xFFE1E0F9),
    tertiary: Color(0xFFE7B9D5),
    onTertiary: Color(0xFF45263C),
    tertiaryContainer: Color(0xFF5E3C53),
    onTertiaryContainer: Color(0xFFFFD7EE),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1B1B1F),
    onBackground: Color(0xFFE5E1E6),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE5E1E6),
    surfaceVariant: Color(0xFF46464F),
    onSurfaceVariant: Color(0xFFC7C5D0),
    outline: Color(0xFF91909A),
    onInverseSurface: Color(0xFF1B1B1F),
    inverseSurface: Color(0xFFE5E1E6),
    inversePrimary: Color(0xFF3946EA),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFBEC2FF),
  );
}
