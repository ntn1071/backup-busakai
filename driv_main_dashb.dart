import 'dart:io';
import 'dart:ui';
import 'package:busakai/screens/driv_notif.dart';
import 'package:busakai/screens/driv_profile.dart';
import 'package:busakai/screens/driv_trip_history.dart';
import 'package:busakai/screens/driv_trip_mngmnt.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverAppWithNavBar extends StatefulWidget {
  const DriverAppWithNavBar({super.key});

  @override
  _DriverAppWithNavBarState createState() => _DriverAppWithNavBarState();
}

class _DriverAppWithNavBarState extends State<DriverAppWithNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreenDriver(),
    const TripManagementScreen(),
    TripHistoryScreen(),
    NotificationsScreenDriv(),
    const ProfileScreenDriv(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Trip Management',
          ),BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Trip History',
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

class DashboardScreenDriver extends StatefulWidget {
  const DashboardScreenDriver({super.key});

  @override
  _DashboardScreenDriverState createState() => _DashboardScreenDriverState();
}

class _DashboardScreenDriverState extends State<DashboardScreenDriver> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImage');
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
        backgroundColor: const Color.fromARGB(255, 50, 109, 197),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!) as ImageProvider
                : const AssetImage('assets/driv_pfp.png'),
          ),
        ),
        title: const Text('BuSakAI Pasigueño'),
        actions: const [Icon(Icons.notifications)],
      ),
      body: Container(
        color: const Color.fromARGB(255, 200, 225, 255),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Day Carlos! Buckle up, Your next trip will be in 5 minutes!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Card(
              elevation: 2,
              child: ListTile(
                title: Text(
                  'Assigned Bus: Bus A',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text('City Hall → Manggahan'),
                trailing: Text(
                  'Passenger Count: 0',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Container for real-time bus location
        
                  const SizedBox(height: 20),
// Inside your DashboardScreen widget
          Container(
            height: 320,
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
                      MaterialPageRoute(builder: (context) => const TripManagementScreen()),
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
      ),
    );
  }
}
