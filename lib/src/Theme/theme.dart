import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    splashColor: Color.fromARGB(255, 255, 255, 255),
    textTheme: TextTheme(),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme.light(
      background: Color(0xFFFFFFFF),
      primary: HexColor("EE6B47"),
      onTertiary: Color.fromARGB(209, 0, 0, 0),
      tertiaryContainer: Color.fromARGB(255, 255, 255, 255),
      onBackground: const Color.fromARGB(255, 56, 56, 56),
      secondary: HexColor("EE6B47"),
      onPrimary: HexColor("EE6B47"),
      onPrimaryContainer: HexColor("EE6B47"),
      onSecondary: HexColor("796B6B"),
      tertiary: Color.fromARGB(255, 140, 140, 140),
      primaryContainer: Colors.amber[600],
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 43, 43, 43),
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 203, 203, 203),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Color.fromARGB(255, 43, 43, 43),
    buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
        colorScheme: ColorScheme.dark(),
        buttonColor: Color.fromARGB(255, 241, 152, 0)),
    colorScheme: ColorScheme.dark(
      onBackground: Color.fromARGB(255, 203, 203, 203),
      onSecondary: HexColor("6D676C"),
      secondary: const Color.fromARGB(255, 151, 151, 151),
      onPrimary: HexColor("EE6B47"),
      onPrimaryContainer: const Color.fromARGB(255, 126, 72, 192),
      background: Colors.grey.shade900,
      tertiaryContainer: Color.fromARGB(255, 43, 43, 43),
      onTertiary: Color.fromARGB(115, 207, 207, 207),
    ));
