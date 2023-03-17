import 'package:flutter/material.dart';

class MahasColors {
  static const Color blue = Color(0xFF2962FF);
  static const Color red = Color(0xFFC62828);
  static const Color yellow = Color(0xFFFFD54F);
  static const Color violet = Color(0xFF6A1B9A);
  static const Color brown = Color(0xFFA66E68);
  static const Color cream = Color(0xFFF2C094);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color green = Color(0xFF43A047);
  static const Color charcoal = Color(0xFF34282C);
  static const Color slate = Color(0xFF2B3856);
  static const Color gunMetal = Color(0xFF2C3539);
  static const Color lGreen = Color(0xFF004225);

  static List<Color> grafikColors = [
    blue,
    red,
    violet,
    brown,
    green,
    charcoal,
    slate,
    gunMetal,
    lGreen
  ];

  static const Color primary = green;
  static const Color light = Colors.white;
  static const Color dark = Colors.black;
  static const Color danger = red;
  static const Color warning = yellow;

  static BoxDecoration decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        MahasColors.cream.withOpacity(.8),
        MahasColors.cream,
      ],
    ),
  );
}
