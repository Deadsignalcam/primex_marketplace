import 'package:flutter/material.dart';

class AppTheme {
  static const bg = Color(0xFF050505);
  static const panel = Color(0xFF0E0E13);
  static const panel2 = Color(0xFF171720);
  static const gold = Color(0xFFD7A847);
  static const gold2 = Color(0xFFFFC766);
  static const text = Colors.white;
  static const muted = Color(0xFFA8A8B3);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Arial',
      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
