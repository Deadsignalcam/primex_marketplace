import 'package:flutter/material.dart';

class PrimeXTheme {
  static const Color black = Color(0xFF020617);
  static const Color dark = Color(0xFF06111F);
  static const Color card = Color(0xFF081827);
  static const Color neonBlue = Color(0xFF00D9FF);
  static const Color electricBlue = Color(0xFF006BFF);
  static const Color cyan = Color(0xFF38F8FF);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    primaryColor: neonBlue,
    fontFamily: 'Arial',
    colorScheme: const ColorScheme.dark(
      primary: neonBlue,
      secondary: electricBlue,
      surface: card,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      foregroundColor: white,
      elevation: 0,
    ),
  );

  static BoxDecoration neonCard = BoxDecoration(
    color: card.withOpacity(.88),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: neonBlue.withOpacity(.65)),
    boxShadow: [
      BoxShadow(
        color: neonBlue.withOpacity(.35),
        blurRadius: 20,
        spreadRadius: 1,
      ),
    ],
  );

  static BoxDecoration neonButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [electricBlue, neonBlue],
    ),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: neonBlue.withOpacity(.55),
        blurRadius: 12,
      ),
    ],
  );
}
