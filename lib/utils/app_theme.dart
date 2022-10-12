import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    final scheme = lightColorScheme ?? AppTheme.lightColorScheme;
    return ThemeData.light().copyWith(
      useMaterial3: true,
      colorScheme: scheme,
      primaryColor: scheme.primary,
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    final scheme = darkColorScheme ?? AppTheme.darkColorScheme;
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: scheme,
      primaryColor: scheme.primary,
    );
  }

  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff7C7B9B),
    primary: const Color(0xff7C7B9B),
    secondary: const Color(0xffFCAAAB),
  );

  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff7C7B9B),
    brightness: Brightness.dark,
  );
}
