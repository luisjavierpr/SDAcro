import 'package:chatui/components/my_post_button.dart';
import 'package:chatui/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatui/components/my_textfield.dart';
import 'package:chatui/components/my_drawer.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key});

  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: MyDrawer(),
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
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          hintText: "Say Something...",
                          obscureText: false,
                          controller: newPostController,
                        ),
                      ),
                      MyPostButton(
                        onTap: postMessage,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                StreamBuilder(
                  stream: database.getPostsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final posts = snapshot.data!.docs;
                    if (snapshot.data == null || posts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: Text('No posts yet... Post something!'),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          String email = post['userEmail'];
                          String message = post['postMessage'];
                          int likesCount = post['likesCount'] ?? 0;
                          Map<String, dynamic> likes =
                              Map<String, dynamic>.from(post['likes'] ?? {});
                          bool isLiked = likes.containsKey(database.user!.uid);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                          color: isLiked
                                              ? Colors.red
                                              : Colors
                                                  .grey, // Change color to red if liked
                                        ),
                                        if (likesCount > 0)
                                          Positioned(
                                            left: 10,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}