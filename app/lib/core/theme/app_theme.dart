import 'package:flutter/material.dart';

const kAccent = Color(0xFFFF9142);

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        surface: Colors.black,
        primary: kAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF111111),
        selectedItemColor: Color(0xFFFF9142),
        unselectedItemColor: Color(0x66FFFFFF),
        type: BottomNavigationBarType.fixed,
      ),
      useMaterial3: true,
    );
  }
}
