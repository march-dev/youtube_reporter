import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const brightness = Brightness.dark;

  static const primaryColor = Colors.yellow;
  static const onPrimaryColor = Colors.black;
  static const backgroundColor = Color(0xFF050F20);
  static const onBackgroundColor = Colors.white;

  static const errorColor = Colors.red;
  static const warningColor = Colors.orange;
  static const successColor = Colors.green;

  static final elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ButtonStyle(
      enableFeedback: true,
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      fixedSize: MaterialStateProperty.all(const Size(300, 40)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );

  static get materialThemeData => ThemeData(
        brightness: brightness,
        primarySwatch: primaryColor,
        errorColor: errorColor,
        backgroundColor: backgroundColor,
        canvasColor: backgroundColor,
        cardColor: backgroundColor,
        elevatedButtonTheme: elevatedButtonThemeData,
      );
}
