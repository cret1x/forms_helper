import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkBlue = ThemeData(
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: Color.fromRGBO(59, 63, 82, 1),
      textTheme: const TextTheme(
          titleMedium: TextStyle(
              fontFamily: 'Veranda',
          )
      ),
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.orange,
          onPrimary: Colors.grey[100]!,
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