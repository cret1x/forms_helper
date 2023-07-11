import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkBlue = ThemeData(
    scaffoldBackgroundColor: Color.fromRGBO(59, 63, 82, 1),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: Colors.white,
      selectionColor: Colors.grey[850]!,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Verdana',
        color: Colors.grey[100],
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Verdana',
        color: Colors.grey[100],
      ),
      titleSmall: TextStyle(
        fontFamily: 'Verdana',
        color: Colors.grey[100],
      ),
      titleMedium: TextStyle(
        fontFamily: 'Verdana',
        color: Colors.grey[100],
      ),
      titleLarge: TextStyle(
        fontFamily: 'Verdana',
        color: Colors.grey[100],
      ),
      labelLarge: const TextStyle(
        fontFamily: 'Verdana',
        fontSize: 14,
        letterSpacing: 0.6,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Verdana',
        fontSize: 18,
        fontWeight: FontWeight.w100,
        color: Colors.grey[100]!.withOpacity(0.6),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
          const Size.fromHeight(50),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 28),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(
            fontFamily: 'Verdana',
            fontSize: 16,
            letterSpacing: 0.6,
          ),
        ),
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromRGBO(73, 73, 73, 1),
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.grey[100]!,
      background: Colors.orange,
      onBackground: Colors.grey[100]!,
      surface: Colors.grey[850]!,
      onSurface: Colors.grey[400]!,
    ),
  );
}
