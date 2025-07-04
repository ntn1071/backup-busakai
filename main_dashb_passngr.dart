import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart'; // Use null-safe swiper
import 'package:shared_preferences/shared_preferences.dart';

// Import your existing screens
import 'pass_route_screen.dart';
import 'pass_my_trips.dart';
import 'pass_notifs.dart';
import 'pass_profile.dart';

class BusPassengerAppHome extends StatefulWidget {
  final String userId; // Add the email parameter

  const BusPassengerAppHome({super.key, required this.userId});

  @override
  _BusPassengerAppHomeState createState() => _BusPassengerAppHomeState();
}

class _BusPassengerAppHomeState extends State<BusPassengerAppHome> {
  int _selectedIndex = 0;
  File? _profileImage;

  late final List<Widget> _screens; // Declare _screens as late variable

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
    _screens = [
      DashboardScreen(),
      RoutesScreen(),
      MyTripsScreen(),
      NotificationsScreen(),
      ProfileScreenDriv(userId: widget.userId), // Pass the email correctly
    ];
  }

  Future<void> _loadProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('${widget.userId}_profile_picture_path');
    setState(() {
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuSakAI Pasiguenio'),
        backgroundColor: const Color.fromARGB(255, 50, 109, 197),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!) as ImageProvider
                : const AssetImage('assets/pass_pfp.png'),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
          // Display email in the app bar (optional)
          
        ],
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trip_origin),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Dashboard Screen with Swiper and updated layout
class DashboardScreen extends StatelessWidget {
  final List<Color> busColors = [
    Colors.blue,
    const Color.fromARGB(255, 176, 176, 176),
    Colors.redAccent,
    Colors.green,
    Colors.purple,
    Colors.brown,
    Colors.orange,
  ];

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height, // Ensuring ListView has height
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'The next bus will arrive in 5 minutes!',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Swiper widget showing 4 bus profiles per slide
          SizedBox(
            height: 110, // Adjust height based on your layout needs
            child: Swiper(
              itemCount: (busColors.length / 4).ceil(), // Round up to ensure full slides
              itemBuilder: (BuildContext context, int index) {
                // Get the range of buses to display on this slide
                int startIndex = index * 4;
                int endIndex = (startIndex + 4) > busColors.length ? busColors.length : startIndex + 4;
                List<Color> busGroup = busColors.sublist(startIndex, endIndex);

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Display 4 bus profiles per row
                    childAspectRatio: 1, // Adjust the size of the grid items
                  ),
                  itemCount: busGroup.length,
                  itemBuilder: (context, index) {
                    final color = busGroup[index];
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: color,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Bus ${startIndex + index + 1}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  },
                );
              },
              autoplay: false,
              pagination: const SwiperPagination(),
              control: const SwiperControl(),
            ),
          ),

          const Divider(height: 32),
          const Text(
            'Nearby Bus',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _busStopTile('City Hall to Bridgetown', 'Bus A', 'Arrival in 5 mins'),
          _busStopTile('Bridgetown to Cityhall', 'Bus D', 'Arrival in 10 mins'),
          const Divider(height: 32),

          // Container for real-time bus location
        
                  const SizedBox(height: 20),
// Inside your DashboardScreen widget
          Container(
            height: 220,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/map_bg.png'), // Replace with your map background image
                fit: BoxFit.cover, // Adjust to cover the container
              ),
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Ensure blur doesn't go outside rounded corners
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Apply blur effect
                    child: Container(
                      color: const Color.fromARGB(137, 120, 120, 120).withOpacity(0.2), // Optional overlay for better contrast
                    ),
                  ),
                  GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RoutesScreen()),
                    );
                  },

                    child: const Center(
                      child: Text(
                        'Realtime Bus Location\n[Click to view]',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 11, 85), // Text color for visibility
                          shadows: [
                            Shadow(
                              offset: Offset(1.5, 1.5),
                              blurRadius: 4.0,
                              color: Colors.black45, // Text shadow for contrast
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }

  Widget _busStopTile(String stopName, String busNumber, String arrivalTime) {
    return ListTile(
      leading: const Icon(Icons.bus_alert, size: 40, color: Colors.blue),
      title: Text(stopName, style: const TextStyle(fontSize: 16)),
      subtitle: Text(busNumber, style: const TextStyle(fontSize: 14)),
      trailing: Text(
        arrivalTime,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
