import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/login.dart';
import 'package:mobile_app_development_evaluation/sign_up.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flight Booking App',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold
              )
            ),
            const Text(
              'Discover your next journey.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontWeight: FontWeight.w500
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0)
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SignUp()
                  )
                );
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0
                  )
                )
              ),
              child: const Text('Sign Up')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Login()
                  )
                );
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                foregroundColor: MaterialStatePropertyAll(Colors.blue),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0
                  )
                )
              ),
              child: const Text('Login')
            )
          ]
        )
      )
    );
  }
}