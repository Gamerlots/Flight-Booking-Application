import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  bool isLoading = true;
  List<dynamic>? bookings;

  Future<String> getBookings() async {
    const int successResponseCode = 200;

    final preferences = await SharedPreferences.getInstance();
    String email = preferences.getString('email') ?? '';

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/get-bookings/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == successResponseCode) {
      return response.body;
    } else {
      throw Exception('Failed to fetch bookings.');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getBookings().then(
      (response) => {
        if (response != 'USER_DOES_NOT_EXIST') {
          setState(() {
            bookings = jsonDecode(response);
            isLoading = false;
          })
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bookingCards = [];
    if (!isLoading) {
      for (int index = 0; index < bookings!.length; index++) {
        bookingCards.add(
            BookingCard(flightInformation: bookings![index])
        );
      }
    } else {
      bookingCards.add(const CircularProgressIndicator());
    }

    return Center(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'My Flights',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold
              )
            ),
          )
        ] + bookingCards
      )
    );
  }
}



class BookingsList extends StatelessWidget {
  const BookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}



class BookingCard extends StatelessWidget {
  final Map<String, dynamic> flightInformation;

  const BookingCard({super.key, required this.flightInformation});

  @override
  Widget build(BuildContext context) {

    List<Widget> passengerInformation = [];
    for (Map<String, dynamic> passenger in flightInformation['passengers']) {
      passengerInformation.add(
        Text('${passenger['name']}: ${passenger['gender']}, ${passenger['age']}, ${passenger['seat']}')
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text('Departure to: ${flightInformation['returnLocation']} at ${flightInformation['departureDate']}'),
            Text('Return to: ${flightInformation['departureLocation']} at ${flightInformation['returnDate']}'),
            Text('Flight duration: ${flightInformation['flightDuration']}')
          ] + passengerInformation,
        ),
      )
    );
  }
}
