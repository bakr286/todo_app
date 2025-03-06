import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.green,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.purple,
  colorScheme: ColorScheme.dark(
    primary: Colors.purple,
    secondary: Colors.blue,
  ),
);

final ThemeData greenLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.green,
  colorScheme: ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.lightBlue,
  ),
);

final ThemeData orangeDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.orange,
  colorScheme: ColorScheme.dark(
    primary: Colors.orange,
    secondary: Colors.yellow,
  ),
);

final List themes = [lightTheme, darkTheme, greenLightTheme, orangeDarkTheme];