import 'package:flutter/material.dart';

class MinimalDarkTheme {
  ThemeData get data => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1A0052),
        backgroundColor: Color(0xFF2B2B2B),
        scaffoldBackgroundColor: Color(0xFF0D0D0D),
        iconTheme: IconThemeData(color: Colors.white),
        dividerColor: Color(0xFF212121),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white, height: 1.25),
          subtitle1: TextStyle(color: Color(0xFF636363), height: 1.25),
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 26.0,
              color: Colors.white,
            ),
          ),
          elevation: 0.0,
          color: Colors.transparent,
        ),
        canvasColor: Colors.transparent,
      );
}
