import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference posts = FirebaseFirestore.instance.collection('Posts');

  Future<void> addPost(String message) {
    return posts.add({
      'userName': user!.displayName,
      'userEmail': user!.email,
      'postMessage': message,
      'timestamp': Timestamp.now(),
      'likesCount': 0, // Initialize likes count to 0
      'likes': {}, // Initialize likes as an empty map
    });
  }

  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return postsStream;
  }

  Future<void> likePost(String postId) async {
    // Get the document reference for the post
    DocumentReference postRef = posts.doc(postId);

    // Get the current likes data
    DocumentSnapshot postSnapshot = await postRef.get();
    Map<String, dynamic> likes = Map<String, dynamic>.from(postSnapshot['likes'] ?? {});

    // Add the current user's UID to the likes map
    likes[user!.uid] = true;

    // Update the likes field in Firestore
    await postRef.update({'likes': likes});

    // Update the likes count
    await postRef.update({'likesCount': FieldValue.increment(1)});
  }

  Future<void> unlikePost(String postId) async {
    // Get the document reference for the post
    DocumentReference postRef = posts.doc(postId);

    // Get the current likes data
    DocumentSnapshot postSnapshot = await postRef.get();
    Map<String, dynamic> likes = Map<String, dynamic>.from(postSnapshot['likes'] ?? {});

    // Remove the current user's UID from the likes map
    likes.remove(user!.uid);

    // Update the likes field in Firestore
    await postRef.update({'likes': likes});

    // Update the likes count
    await postRef.update({'likesCount': FieldValue.increment(-1)});
  }
}