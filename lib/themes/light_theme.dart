import 'package:flutter/material.dart';

class MinimalLightTheme {
  ThemeData get data => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF00C2FF),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        dividerColor: Color(0xFFF1F1F1),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black, height: 1.25),
          subtitle1: TextStyle(color: Color(0xFFD5D5D5), height: 1.25),
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 26.0,
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
          color: Colors.transparent,
        ),
        canvasColor: Colors.transparent,
      );
}
