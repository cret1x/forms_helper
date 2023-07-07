import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkBlue = ThemeData(
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Color.fromRGBO(59, 63, 82, 1),
    textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Verdana',
          color: Colors.grey[100],
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Verdana',
          color: Colors.grey[100],
        ),
        titleMedium: TextStyle(
          fontFamily: 'Verdana',
          color: Colors.grey[100],
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Verdana',
          fontSize: 14,
          letterSpacing: 0.6,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
          Size.fromHeight(50),
        ),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 28),),
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromRGBO(73, 73, 73, 1),
      onPrimary: Colors.white,
      secondary: Colors.orange,
      onSecondary: Colors.orange,
      error: Colors.redAccent,
      onError: Colors.grey[100]!,
      background: Colors.orange,
      onBackground: Colors.grey[100]!,
      surface: Colors.grey[850]!,
      onSurface: Colors.grey[100]!,
    ),
  );
}
