import 'package:flutter/material.dart';

import '../res/font_res.dart';
import 'color_schemes.dart';

class ThemeHelper {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      brightness: Brightness.light,
      fontFamily: 'Montserrat-Medium',
      cardTheme: const CardTheme(surfaceTintColor: Colors.white),
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontFamily: FontRes.MONTSERRAT_BOLD, fontSize: 24),
        headlineMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_BOLD, fontSize: 20),
        headlineSmall:
            TextStyle(fontFamily: FontRes.MONTSERRAT_BOLD, fontSize: 18),
        titleLarge:
            TextStyle(fontFamily: FontRes.MONTSERRAT_SEMIBOLD, fontSize: 18),
        titleMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_SEMIBOLD, fontSize: 16),
        titleSmall:
            TextStyle(fontFamily: FontRes.MONTSERRAT_SEMIBOLD, fontSize: 14),
        bodyLarge:
            TextStyle(fontFamily: FontRes.MONTSERRAT_REGULAR, fontSize: 16),
        bodyMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_REGULAR, fontSize: 14),
        bodySmall:
            TextStyle(fontFamily: FontRes.MONTSERRAT_REGULAR, fontSize: 14),
        labelMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_LIGHT, fontSize: 14),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      brightness: Brightness.dark,
      fontFamily: 'Montserrat-Medium',
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontFamily: FontRes.MONTSERRAT_BOLD, fontSize: 24),
        headlineMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_BOLD, fontSize: 20),
        headlineSmall:
            TextStyle(fontFamily: FontRes.MONTSERRAT_BOLD, fontSize: 18),
        titleLarge:
            TextStyle(fontFamily: FontRes.MONTSERRAT_SEMIBOLD, fontSize: 18),
        titleMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_SEMIBOLD, fontSize: 16),
        titleSmall:
            TextStyle(fontFamily: FontRes.MONTSERRAT_SEMIBOLD, fontSize: 14),
        bodyLarge:
            TextStyle(fontFamily: FontRes.MONTSERRAT_REGULAR, fontSize: 16),
        bodyMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_REGULAR, fontSize: 14),
        bodySmall:
            TextStyle(fontFamily: FontRes.MONTSERRAT_REGULAR, fontSize: 14),
        labelMedium:
            TextStyle(fontFamily: FontRes.MONTSERRAT_LIGHT, fontSize: 14),
      ),
    );
  }
}
