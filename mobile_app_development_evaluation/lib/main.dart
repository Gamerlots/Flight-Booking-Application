import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/home.dart';
import 'package:mobile_app_development_evaluation/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // final preferences = await SharedPreferences.getInstance();
  // String currentUser = preferences.getString('email') ?? '';

  runApp(MaterialApp(
    // home: (currentUser == '') ? const Home() : const MainPage(),
    home: const Home(),
    title: 'Flight Booking App',
    theme: ThemeData(
      cardColor: Colors.lightBlue,
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.lightBlue[50]
      )
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    )
  ));
}

