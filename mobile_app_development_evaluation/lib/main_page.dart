import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/bookings.dart';
import 'package:mobile_app_development_evaluation/my_bookings.dart';
import 'package:mobile_app_development_evaluation/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  List<Widget> screens = [
    const Bookings(),
    const MyBookings(),
    const Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.flight),
            label: 'Book Flight'
          ),
          NavigationDestination(
            icon: Icon(Icons.airplane_ticket),
            label: 'My Flights'
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings'
          )
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
      ),
    );
  }
}
