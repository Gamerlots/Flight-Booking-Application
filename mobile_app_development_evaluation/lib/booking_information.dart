import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_development_evaluation/congratulations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = GlobalKey<FormState>();

class BookingsInformation extends StatefulWidget {
  final String departureLocation;
  final String returnLocation;
  final String flightDuration;

  const BookingsInformation(
    {
      super.key,
      required this.departureLocation,
      required this.returnLocation,
      required this.flightDuration
    }
  );

  @override
  State<BookingsInformation> createState() => _BookingsInformationState();
}

class _BookingsInformationState extends State<BookingsInformation> {
  List<PassengerInput> passengerInputs = [PassengerInput(index: 1)];
  int numberOfPassengers = 1;

  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();

  Future<String> addBooking() async {
    // Defines the success response code.
    const int successResponseCode = 200;

    // Loads the user's email address from the disk.
    final preferences = await SharedPreferences.getInstance();
    String email = preferences.getString('email') ?? '';

    // Fetches all of the information from each passenger.
    List<Map<String, dynamic>> passengers = [];
    for (PassengerInput passengerInput in passengerInputs) {
      Map<String, String> passengerInformation = passengerInput.getPassengerInformation();
      passengers.add(passengerInformation);
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/add-booking/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'bookingInformation': <String, dynamic>{
          'departureDate': departureDateController.text,
          'departureLocation': widget.departureLocation,
          'returnDate': returnDateController.text,
          'returnLocation': widget.returnLocation,
          'flightDuration': widget.flightDuration,
          'passengers': passengers,
        }
      }),
    );

    if (response.statusCode == successResponseCode) {
      return response.body;
    } else {
      throw Exception('Failed to create user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(8.0)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: departureDateController,
                        decoration: const InputDecoration(
                          labelText: 'Departure date',
                          filled: true,
                          prefixIcon: Icon(Icons.flight_takeoff),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(departureDateController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: returnDateController,
                        decoration: const InputDecoration(
                          labelText: 'Return date',
                          filled: true,
                          prefixIcon: Icon(Icons.flight_land),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(returnDateController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: passengerInputs
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      passengerInputs.add(
                        PassengerInput(index: passengerInputs.length + 1)
                      );
                    });
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
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add Passenger')
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addBooking().then(
                          (response) => {
                            if (response == 'SUCCESS') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const Congratulations()
                                )
                              )
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.0
                                        ),
                                        child: Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text('The booking did not upload successfully.'),
                                    ]
                                  ),
                                  backgroundColor: Colors.redAccent,
                                )
                              )
                            }
                          }
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.greenAccent[400]),
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 25.0
                        )
                      )
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Finish Booking')
                  ),
                )
              ]
            ),
          ),
        )
      )
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31)
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toString().split(" ")[0];
      });
    }
  }
}



class PassengerInput extends StatefulWidget {
  final int index;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController seatController = TextEditingController();

  PassengerInput({super.key, required this.index});

  Map<String, String> getPassengerInformation() {
    return {
      'name': nameController.text,
      'age': ageController.text,
      'gender': genderController.text,
      'seat': seatController.text,
    };
  }

  @override
  State<PassengerInput> createState() => _PassengerInputState();
}

class _PassengerInputState extends State<PassengerInput> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Passenger ${widget.index}',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            )
          ),
          TextFormField(
            controller: widget.nameController,
            decoration: const InputDecoration(
              label: Text('Name'),
              border: OutlineInputBorder()
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid name.';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.ageController,
                  decoration: const InputDecoration(
                    label: Text('Age'),
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid age.';
                    }
                    return null;
                  },
                )
              ),
              DropdownMenu(
                label: const Text('Gender'),
                controller: widget.genderController,
                dropdownMenuEntries: const <DropdownMenuEntry>[
                  DropdownMenuEntry(value: 'Male', label: 'Male'),
                  DropdownMenuEntry(value: 'Female', label: 'Female')
                ]
              ),
              DropdownMenu(
                label: const Text('Seat'),
                controller: widget.seatController,
                dropdownMenuEntries: const <DropdownMenuEntry>[
                  DropdownMenuEntry(value: '36A', label: '36A'),
                  DropdownMenuEntry(value: '36B', label: '36B'),
                  DropdownMenuEntry(value: '36C', label: '36C'),
                  DropdownMenuEntry(value: '37A', label: '37A'),
                  DropdownMenuEntry(value: '37B', label: '37B'),
                  DropdownMenuEntry(value: '37C', label: '37C'),
                ]
              )
            ]
          )
        ]
      ),
    );
  }
}