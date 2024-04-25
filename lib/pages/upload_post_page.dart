import 'package:flutter/material.dart';
import 'package:chatui/database/firestore.dart'; // Firestore database operations

class UploadPostPage extends StatelessWidget {
  UploadPostPage({Key? key}) : super(key: key);

  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController _postController = TextEditingController();

  void postMessage(BuildContext context) {
    if (_postController.text.isNotEmpty) {
      String message = _postController.text;
      database.addPost(message); // Function to add a post to Firestore
      Navigator.pop(context); // Navigate back after posting
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some text to post.")) // Show a snackbar if the input is empty
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your post here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => postMessage(context),
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
