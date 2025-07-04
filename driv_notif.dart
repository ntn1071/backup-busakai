import 'package:flutter/material.dart';

class NotificationsScreenDriv extends StatelessWidget {
   NotificationsScreenDriv({super.key});

  // Dummy notifications data
  final List<Map<String, String>> notifications = [
    
    {
      'title': 'New Trip Assigned',
      'description': 'Your next trip is from City Hall to Manggahan.',
      'time': '2 hours ago',
    },
    {
      'title': 'Reminder: Rest Break',
      'description': 'It\'s time for a 10-minute rest break at the terminal.',
      'time': '5 hours ago',
    },
    {
      'title': 'Traffic Alert',
      'description': 'Heavy traffic reported on the route to Manggahan.',
      'time': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color.fromARGB(255, 50, 109, 197),
        centerTitle: true,
      ),
      body: Container(
         padding: const EdgeInsets.only(top: 20.0), // Add space before the list
         color: const Color.fromARGB(255, 200, 225, 255),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  notification['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(notification['description']!),
                trailing: Text(
                  notification['time']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
