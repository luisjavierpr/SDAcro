import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'event_details_page.dart';

class EventsPage extends StatelessWidget {
  EventsPage({super.key});

  // Sample event data (replace with your data fetching logic)
  final List<Map<String, String>> events = [
    {
      'name': 'Acrofest 2024',
      'date': 'November 6-9, 2024',
      'location': 'Southwestern Adventist University',
      'description': '"Send Me"',
      
      'scheduleUrl':
          'https://drive.google.com/file/d/1FLmKCl-feW9kbEgO83twcXp4hZo3SRBB/view?usp=sharing',
      'mealScheduleUrl':
          'https://drive.google.com/file/d/15EIDSFI1qwPvRUIYNsidqFZx8kwHcuJO/view?usp=sharing',
      'thursdayClinicUrl':
          'https://drive.google.com/file/d/1E5lvWkW2LNVhMhWpeHGVxVPJoCopS8CV/view?usp=sharing',
      'fridayPerformanceUrl':
          'https://drive.google.com/file/d/1CRkCx9mRxdQ0ZbDzQ9o3fMW7b_PIX5z6/view?usp=sharing',
    },

    // Add more events as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              // Navigate to the calendar page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event['name'] ?? ''),
            subtitle:
                Text('${event['date'] ?? ''} - ${event['location'] ?? ''}'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              // Navigate to the event details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
