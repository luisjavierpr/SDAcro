import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs

class EventDetailsPage extends StatelessWidget {
  final Map<String, String> event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['name'] ?? ''),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${event['date'] ?? 'No date available'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: ${event['location'] ?? 'No location available'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              event['description'] ?? 'No description available.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _launchURL(event['scheduleUrl'] ?? '', context),
              icon: Icon(Icons.calendar_today),
              label: Text('Acrofest 2024 Schedule'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  _launchURL(event['mealScheduleUrl'] ?? '', context),
              icon: Icon(Icons.fastfood),
              label: Text('Meal Schedule'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  _launchURL(event['thursdayClinicUrl'] ?? '', context),
              icon: Icon(Icons.calendar_today),
              label: Text('Thursday Clinic Schedule'),
            ),
            SizedBox(height: 10),
            if (event['fridayPerformanceUrl']?.isNotEmpty ?? false) ...[
              ElevatedButton.icon(
                onPressed: () =>
                    _launchURL(event['fridayPerformanceUrl'] ?? '', context),
                icon: Icon(Icons.calendar_today),
                label: Text('Friday Performance Details'),
              ),
              SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  void _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }
}
