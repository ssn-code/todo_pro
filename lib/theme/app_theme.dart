import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const accent = Color(0xFF7555A5);

  static final light = _buildTheme(
    brightness: Brightness.light,
    background: const Color(0xFFFFFFFF),
    foreground: const Color(0xFF19171D),
    muted: const Color(0xFF77737D),
    border: const Color(0xFFE8E6EB),
    surface: const Color(0xFFFAF9FB),
  );

  static final dark = _buildTheme(
    brightness: Brightness.dark,
    background: const Color(0xFF1C1B1F),
    foreground: const Color(0xFFF2F0F5),
    muted: const Color(0xFFAAA6B0),
    border: const Color(0xFF38363D),
    surface: const Color(0xFF252329),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color foreground,
    required Color muted,
    required Color border,
    required Color surface,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      secondary: accent,
      onSecondary: Colors.white,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: surface,
      onSurface: foreground,
      outline: border,
      outlineVariant: border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      dividerColor: border,
      textTheme: ThemeData(brightness: brightness).textTheme
          .apply(bodyColor: foreground, displayColor: foreground),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}
