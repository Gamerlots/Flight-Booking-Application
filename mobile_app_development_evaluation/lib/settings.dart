import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void logOut() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('email', '');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              logOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Home()
                )
              );
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red),
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0
                )
              )
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out')
          ),
        ],
      )
    );
  }
}

