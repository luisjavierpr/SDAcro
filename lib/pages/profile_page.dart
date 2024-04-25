import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatui/services/chat/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key});

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: _buildUserProfile(context),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: _getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data != null) {
          // Extract user data
          Map<String, dynamic>? user = snapshot.data!.data();

          if (user != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    user['username'] ?? 'Username not set',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user['email'] ?? 'Email not available',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No Data'),
            );
          }
        } else {
          // User is not logged in or data is not available
          return Center(
            child: Text('User is not logged in.'),
          );
        }
      },
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if a user is logged in
    if (currentUser != null) {
      // Fetch user details using their email
      return await _chatService.getUserDetails(currentUser.email!);
    } else {
      // User is not logged in, handle this case gracefully
      return null;
    }
  }
}
