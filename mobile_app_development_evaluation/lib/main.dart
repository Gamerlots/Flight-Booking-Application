import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/home.dart';

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    title: 'Flight Booking App',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.lightBlue[50]
      ),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    ),
  ));
}

