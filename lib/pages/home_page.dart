import 'package:flutter/material.dart';
import 'package:chatui/components/my_drawer.dart'; // Custom drawer widget
import 'package:chatui/database/firestore.dart'; // Firestore database operations
import 'package:chatui/pages/upload_post_page.dart'; // Import the UploadPostPage

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final FirestoreDatabase database = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: MyDrawer(), // Your custom drawer widget
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'S D A c r o',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70), // Reduced padding to bring posts closer to the top text
            child: StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No posts yet... Post something!"));
                } else {
                  var posts = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      String email = post['userEmail'];
                      String message = post['postMessage'];
                      int likesCount = post['likesCount'] ?? 0;
                      Map<String, dynamic> likes = Map<String, dynamic>.from(post['likes'] ?? {});
                      bool isLiked = likes.containsKey(database.user!.uid);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: Colors.grey.shade200,
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  email,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  if (isLiked) {
                                    database.unlikePost(post.id);
                                  } else {
                                    database.likePost(post.id);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: isLiked ? Colors.red : Colors.grey,
                                    ),
                                    if (likesCount > 0)
                                      Positioned(
                                        left: 10,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          child: Text(
                                            likesCount.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadPostPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Upload New Post', // Tooltip for accessibility
      ),
    );
  }
}
