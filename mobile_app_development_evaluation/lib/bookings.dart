import 'package:flutter/material.dart';
import 'package:mobile_app_development_evaluation/booking_information.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Book Flight',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: "Search the world's flights...",
                leading: const Icon(Icons.search),
                onChanged: (value) {
                  setState(() {
                    searchFilter = value;
                  });
                },
                padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 14.0)
                ),
                elevation: const MaterialStatePropertyAll<double>(3.0),
                shadowColor: const MaterialStatePropertyAll<Color>(
                  Colors.indigo
                ),
              ),
            ),
            FlightsList(searchFilter: searchFilter),
          ]
        ),
      )
    );
  }
}

class FlightCard extends StatelessWidget {
  final Map<String, String> flightInformation;

  const FlightCard({super.key, required this.flightInformation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Text(
              flightInformation['name']!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  flightInformation['start']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0
                  )
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.arrow_forward,
                      size: 28.0
                    ),
                    Text(
                      flightInformation['duration']!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0
                      )
                    )
                  ],
                ),
                Text(
                  flightInformation['end']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0
                  )
                )
              ]
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => BookingsInformation(
                      flightDuration: flightInformation['duration']!,
                      departureLocation: flightInformation['start']!,
                      returnLocation: flightInformation['end']!,
                    )
                  )
                );
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.white)
              ),
              icon: const Icon(Icons.airplane_ticket),
              label: const Text("Book")
            )
          ]
        ),
      )
    );
  }
}

class FlightsList extends StatefulWidget {
  final String searchFilter;

  const FlightsList({super.key, required this.searchFilter});

  @override
  State<FlightsList> createState() => _FlightsListState();
}

class _FlightsListState extends State<FlightsList> {
  final List<Map<String, String>> flights = [
    {'name': '6E 537', 'start': 'LAX', 'end': 'SFO', 'duration': '3h 17m'},
    {'name': 'AM 142', 'start': 'HNL', 'end': 'ATL', 'duration': '8h 49m'},
    {'name': 'U7 689', 'start': 'CLE', 'end': 'MCO', 'duration': '4h 52m'},
    {'name': '1B 031', 'start': 'DFW', 'end': 'IAD', 'duration': '1h 38m'},
    {'name': '4K 725', 'start': 'CVG', 'end': 'DCA', 'duration': '2h 25m'},
    {'name': '4K 725', 'start': 'CVG', 'end': 'DCA', 'duration': '2h 25m'},
    {'name': '4K 725', 'start': 'CVG', 'end': 'DCA', 'duration': '2h 25m'},
  ];

  @override
  Widget build(BuildContext context) {
    List<FlightCard> flightCards = [];
    for (final flight in flights) {
      bool isFiltered = true;
      for (final value in flight.values) {
        if (value.toLowerCase().contains(widget.searchFilter.toLowerCase())) {
          isFiltered = false;
        }
      }
      if (!isFiltered) {
        flightCards.add(FlightCard(flightInformation: flight));
      }
    }
    return Column(children: flightCards);
  }
}

