import 'package:flutter/material.dart';
import 'package:chatui/components/user_tile.dart';
import 'package:chatui/pages/chat_page.dart';
import 'package:chatui/services/auth/auth_service.dart';
import 'package:chatui/services/chat/chat_services.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: _buildUserList(context),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic>? userData, BuildContext context) {
    if (userData == null || userData["username"] == null) {
      return const SizedBox(); 
    }
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["username"],  // Use the username instead of email
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData ["uid"], 
                receiverUsername: userData["username"],  // Pass the username
                receiverUid: '', 
                chatRoomId: '', 
              ),
            ),
          );
        },
        selected: true,
      );
    } else {
      return Container();
    }
  }
}
