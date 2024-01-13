import 'package:flutter/material.dart';
import 'bookings.dart';

class Congratulations extends StatelessWidget {
  const Congratulations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Icon(
                Icons.check_circle,
                size: 72.0,
                color: Colors.greenAccent[400]
              )
            ),
            const Text(
              'Congratulations',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold
              )
            ),
            const Text(
              'Your next journey is booked.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontWeight: FontWeight.w500
              )
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0)
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Bookings()
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
              child: const Text("Return to Main Screen")
            )
          ]
        )
      ),
    );
  }
}