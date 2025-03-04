import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.lightBlue, // Light theme secondary color
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.purple,
  colorScheme: ColorScheme.dark(
    primary: Colors.purple,
    secondary: Colors.deepPurple, // Dark theme secondary color
  ),
);
