import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Tutorials',
      home: ResourcesPage(),
    );
  }
}

class VideoData {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;

  VideoData({required this.title, required this.description, required this.videoUrl, required this.thumbnailUrl});

  factory VideoData.fromFirestore(Map<String, dynamic> firestore) {
    return VideoData(
      title: firestore['title'] as String? ?? 'No Title',
      description: firestore['description'] as String? ?? 'No Description',
      videoUrl: firestore['videoUrl'] as String? ?? '',
      thumbnailUrl: firestore['thumbnailUrl'] as String? ?? '',
    );
  }
}

class ResourcesPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<VideoData>> getVideos() {
    return _firestore.collection('videos').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => VideoData.fromFirestore(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acrobatic Tutorials'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: StreamBuilder<List<VideoData>>(
        stream: getVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var video = snapshot.data![index];
                return VideoItem(
                  title: video.title,
                  description: video.description,
                  thumbnailUrl: video.thumbnailUrl,
                  videoUrl: video.videoUrl,
                );
              },
            );
          } else {
            return Center(child: Text('No videos found'));
          }
        },
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;  // Optional: assuming you might have duration data

  const VideoItem({
    Key? key,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.duration = '',  // Default empty if not used
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(videoUrl),
      child: Padding(
        padding: const EdgeInsets.only(top: 50), // Add top padding here
        child: Container(
          margin: EdgeInsets.all(10),
          child: Stack(
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
