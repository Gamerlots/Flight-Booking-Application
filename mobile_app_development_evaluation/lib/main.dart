import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/home.dart';

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    title: 'Flight Booking App',
    theme: ThemeData(
      cardColor: Colors.lightBlue
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    )
  ));
}

