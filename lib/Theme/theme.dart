import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
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
      onSecondary: HexColor("796B6B"),
      primaryContainer: Colors.amber[600],
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
        colorScheme: ColorScheme.dark(),
        buttonColor: Color.fromARGB(255, 241, 152, 0)),
    colorScheme: ColorScheme.dark(
      onBackground: Color.fromARGB(255, 203, 203, 203),
      onSecondary: HexColor("6D676C"),
      secondary: const Color.fromARGB(255, 151, 151, 151),
      onPrimary: HexColor("EE6B47"),
      primaryContainer: Colors.amber[600],
      background: Colors.grey.shade900,
      tertiaryContainer: Color.fromARGB(255, 43, 43, 43),
      onTertiary: Color.fromARGB(115, 207, 207, 207),
    ));
