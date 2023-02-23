import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../mahas_colors.dart';

class MahasThemes {
  static double borderRadius = 10;

  static ThemeData light = ThemeData(
    fontFamily: GoogleFonts.quicksand().fontFamily,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        backgroundColor: MahasColors.primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(88, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MahasColors.primary,
    ),
  );

  static TextStyle blackH1 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: MahasColors.dark,
  );
  static TextStyle whiteH1 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: MahasColors.light);

  static TextStyle blackH2 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: MahasColors.dark,
  );
  static TextStyle whiteH2 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: MahasColors.light,
  );

  static TextStyle blackH3 = const TextStyle(
    fontSize: 16,
    color: MahasColors.dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle greenH3 = const TextStyle(
    fontSize: 16,
    color: MahasColors.green,
    fontWeight: FontWeight.bold,
  );
  static TextStyle whiteH3 = const TextStyle(
    fontSize: 16,
    color: MahasColors.light,
    fontWeight: FontWeight.bold,
  );

  static TextStyle blackNormal = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: MahasColors.dark,
  );
  static TextStyle whiteNormal = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: MahasColors.light,
  );
  static TextStyle mutedNormal = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: MahasColors.grey,
  );
  static TextStyle linkNormal = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: MahasColors.blue,
  );

  static InputDecoration? textFiendDecoration({
    hintText,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      hintText: hintText,
    );
  }
}
