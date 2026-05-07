import 'package:flutter/material.dart';

class AppTheme {
  static const bg = Color(0xFF030814);
  static const panel = Color(0xFF07111F);
  static const panel2 = Color(0xFF0A1426);
  static const border = Color(0xFF172A46);
  static const blue = Color(0xFF086BFF);
  static const gold = Color(0xFFFFB22C);
  static const text = Color(0xFFF5F7FF);
  static const muted = Color(0xFF9AA7BA);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    fontFamily: 'Times New Roman',
    colorScheme: const ColorScheme.dark(
      primary: blue,
      secondary: gold,
      surface: panel,
    ),
  );
}
