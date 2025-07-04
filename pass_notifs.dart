import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // List of notifications grouped by categories
  final Map<String, List<Map<String, dynamic>>> notifications = {
    'Real-Time Alerts': [
      {'title': 'Bus A is delayed due to traffic', 'isRead': false},
      {'title': 'Bus D will arrive in 5 minutes', 'isRead': false},
    ],
    'Trip Reminders': [
      {'title': 'Trip Reminder: Bus E departs in 10 minutes', 'isRead': false},
      {'title': 'Trip Reminder: Bus A is on its way', 'isRead': false},
    ],
    'System Updates': [
      {'title': 'New features added: real-time bus tracking', 'isRead': false},
      {'title': 'App update: Bug fixes for better performance', 'isRead': false},
    ],
  };

  // Function to mark a notification as read
  void _markAsRead(String category, int index) {
    setState(() {
      notifications[category]?[index]['isRead'] = true;
    });
  }

  // Function to open and view the notification details (for simplicity, just a dialog)
  void _readNotification(String category, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notifications[category]?[index]['title'] ?? 'No Title'),
          content: const Text('This is a detailed view of the notification.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: notifications.entries.map((entry) {
          // Category section title
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  entry.key,  // The category name
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              // Divider between the category and the notifications
              const Divider(
                thickness: 2,
                color: Colors.blueAccent,
              ),
              // Notifications for this category
              for (var i = 0; i < entry.value.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    tileColor: entry.value[i]['isRead']
                        ? Colors.grey[200]
                        : Colors.white,
                    title: Text(
                      entry.value[i]['title'],
                      style: TextStyle(
                        fontWeight: entry.value[i]['isRead']
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: entry.value[i]['isRead']
                        ? null
                        : const Text('New notification'),
                    trailing: entry.value[i]['isRead']
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.mark_as_unread),
                            onPressed: () => _markAsRead(entry.key, i),
                          ),
                    onTap: () => _readNotification(entry.key, i),
                  ),
                ),
              // Divider between notifications within the same category
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
