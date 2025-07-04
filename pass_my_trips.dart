import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  _MyTripsScreenState createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  // List of trip history data
  final List<Map<String, String>> allTrips = [
    {'date': '2024-12-01', 'time': '08:00 AM', 'route': 'City Hall to Bridgetown', 'bus': 'Bus A'},
    {'date': '2024-12-02', 'time': '10:30 AM', 'route': 'Bridgetown to City Hall', 'bus': 'Bus B'},
    {'date': '2024-12-03', 'time': '05:15 PM', 'route': 'City Hall to Bridgetown', 'bus': 'Bus A'},
    {'date': '2024-12-04', 'time': '07:45 AM', 'route': 'Bridgetown to City Hall', 'bus': 'Bus D'},
    {'date': '2024-12-05', 'time': '06:00 PM', 'route': 'City Hall to Bridgetown', 'bus': 'Bus C'},
  ];

  List<Map<String, String>> filteredTrips = [];
  final TextEditingController _searchController = TextEditingController();
  String? selectedRoute;
  String? selectedBus;
  String selectedSort = 'Date (Newest)'; // Default sorting option

  @override
  void initState() {
    super.initState();
    filteredTrips = allTrips; // Initially show all trips
  }

  // Function to filter trips based on search criteria (date, route, bus)
  void _filterTrips(String inputDate) {
    if (inputDate.isEmpty) {
      setState(() {
        filteredTrips = allTrips;
      });
      return;
    }

    setState(() {
      filteredTrips = allTrips.where((trip) {
        final formattedDate = _formatDate(trip['date']!);
        return formattedDate.toLowerCase().contains(inputDate.toLowerCase());
      }).toList();
    });
  }

  // Function to format the date (e.g., 2024-12-01 -> December 1, 2024)
  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMMM d, yyyy').format(parsedDate);
  }

  // Function to filter by route
  void _filterByRoute(String? route) {
    setState(() {
      selectedRoute = route;
      filteredTrips = allTrips.where((trip) {
        if (route == null || route.isEmpty) return true;
        return trip['route']!.toLowerCase().contains(route.toLowerCase());
      }).toList();
    });
  }

  // Function to filter by bus
  void _filterByBus(String? bus) {
    setState(() {
      selectedBus = bus;
      filteredTrips = allTrips.where((trip) {
        if (bus == null || bus.isEmpty) return true;
        return trip['bus']!.toLowerCase().contains(bus.toLowerCase());
      }).toList();
    });
  }

  // Function to sort the trips by date
  void _sortTrips(String sortOption) {
    setState(() {
      selectedSort = sortOption;
      if (sortOption == 'Date (Newest)') {
        filteredTrips.sort((a, b) => DateTime.parse(b['date']!).compareTo(DateTime.parse(a['date']!)));
      } else if (sortOption == 'Date (Oldest)') {
        filteredTrips.sort((a, b) => DateTime.parse(a['date']!).compareTo(DateTime.parse(b['date']!)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 227, 234, 241),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search by Date (e.g., December 1, 2024)',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filterTrips,
            ),
          ),
          // Wrap for compact sorting and filtering options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                // Route filter
                SizedBox(
                  width: 140,
                  child: DropdownButton<String>(
                    value: selectedRoute,
                    hint: const Text('Route'),
                    isExpanded: true,
                    onChanged: (newRoute) => _filterByRoute(newRoute),
                    items: [
                      null,
                      'City Hall to Bridgetown',
                      'Bridgetown to City Hall',
                    ]
                        .map<DropdownMenuItem<String>>((String? route) {
                      return DropdownMenuItem<String>(
                        value: route,
                        child: Text(route ?? 'All Routes'),
                      );
                    }).toList(),
                  ),
                ),
                // Bus filter
                SizedBox(
                  width: 140,
                  child: DropdownButton<String>(
                    value: selectedBus,
                    hint: const Text('Bus'),
                    isExpanded: true,
                    onChanged: (newBus) => _filterByBus(newBus),
                    items: [
                      null,
                      'Bus A',
                      'Bus D',
                      'Bus B',
                      'Bus E',
                    ]
                        .map<DropdownMenuItem<String>>((String? bus) {
                      return DropdownMenuItem<String>(
                        value: bus,
                        child: Text(bus ?? 'All Buses'),
                      );
                    }).toList(),
                  ),
                ),
                // Sort filter
                SizedBox(
                  width: 140,
                  child: DropdownButton<String>(
                    value: selectedSort,
                    onChanged: (sortOption) => _sortTrips(sortOption!),
                    items: const [
                      DropdownMenuItem(value: 'Date (Newest)', child: Text('Newest')),
                      DropdownMenuItem(value: 'Date (Oldest)', child: Text('Oldest')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Trip History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: filteredTrips.isEmpty
                ? const Center(
                    child: Text('No trips found.'),
                  )
                : ListView.builder(
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = filteredTrips[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(trip['date']!),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    trip['time']!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Route: ${trip['route']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Bus: ${trip['bus']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
