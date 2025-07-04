import 'package:busakai/screens/driv_main_dashb.dart';
import 'package:flutter/material.dart';

class TripHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> tripHistory = [
    {
      'date': '2024-12-01',
      'time': '08:30 AM',
      'route': 'City Hall to Bridgetown',
      'passengerNumber': '25',
    },
    {
      'date': '2024-12-02',
      'time': '09:00 AM',
      'route': 'Bridgetown to City Hall',
      'passengerNumber': '30',
    },
    {
      'date': '2024-12-03',
      'time': '01:00 PM',
      'route': 'City Hall to Bridgetown',
      'passengerNumber': '15',
    },
    {
      'date': '2024-12-04',
      'time': '10:00 AM',
      'route': 'City Hall to Bridgetown',
      'passengerNumber': '20',
    },
    {
      'date': '2024-12-04',
      'time': '11:00 AM',
      'route': 'Bridgetown to City Hall',
      'passengerNumber': '15',
    }
  ];

  TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // This ensures that when the back button is pressed, it goes directly to the Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverAppWithNavBar()),
        );
        return false; // Prevents the default back action
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trip History'),
          backgroundColor: const Color.fromARGB(255, 50, 109, 197),
        ),
        body: Container(
          color: const Color.fromARGB(255, 200, 225, 255),
          padding: const EdgeInsets.only(top: 20.0), // Add space before the list
          child: ListView.builder(
            itemCount: tripHistory.length,
            itemBuilder: (context, index) {
              var trip = tripHistory[index];
             return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    '\nRoute: ${trip['route']}\n',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.date_range, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('Date: ${trip['date']}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('Time: ${trip['time']}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('Passenger Number: ${trip['passengerNumber']}\n'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}