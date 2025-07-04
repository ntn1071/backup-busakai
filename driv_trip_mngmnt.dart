import 'package:busakai/screens/driv_main_dashb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Use LatLng from latlong2 package

class TripManagementScreen extends StatefulWidget {
  const TripManagementScreen({super.key});

  @override
  _TripManagementScreenState createState() => _TripManagementScreenState();
}

class _TripManagementScreenState extends State<TripManagementScreen> {
  final LatLng _currentLocation = LatLng(14.593756, 121.086214); // Example: Manila coordinates
  bool isTripStarted = false;

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
          title: const Text('Trip Management'),
          backgroundColor: const Color.fromARGB(255, 50, 109, 197),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(5, 30,   5, 0),
          color: const Color.fromARGB(255, 200, 225, 255),
          child: Column(
            children: [
              // Map Section with padding and border radius
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Add padding around the map
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0), // Border radius for the map container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), // Apply border radius to the map itself
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentLocation,
                          initialZoom: 17.0,
                          maxZoom: 20.0,
                          minZoom: 10.0,
                         // Allow interactions like pinch, pan
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.app', // Add your app's package name
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentLocation,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Buttons Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    // Start Trip and End Trip Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: isTripStarted
                              ? null // Disable the button if the trip has already started
                              : () {
                                  setState(() {
                                    isTripStarted = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Trip Started')),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTripStarted
                                ? Colors.grey
                                : const Color.fromARGB(255, 8, 139, 60), // Green color
                            foregroundColor: Colors.white, // Set text color to white
                          ),
                          child: const Text('Start Trip'),
                        ),
                        ElevatedButton(
                          onPressed: !isTripStarted
                              ? null // Disable the button if the trip hasn't started
                              : () {
                                  setState(() {
                                    isTripStarted = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Trip Ended')),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isTripStarted
                                ? Colors.grey
                                : const Color.fromARGB(255, 202, 13, 13), // Red color
                            foregroundColor: Colors.white, // Set text color to white
                          ),
                          child: const Text('End Trip'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Report an Issue Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Report an Issue')),
                          );
                          // Navigate to a new "Report Issue" screen or show a dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 244, 183, 39), // Yellow color
                          foregroundColor: Colors.black, // Set text color to black
                        ),
                        child: const Text('Report an Issue'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
