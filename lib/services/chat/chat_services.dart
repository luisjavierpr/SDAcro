import 'package:chatui/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Instance of Firestore & Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Go through each user
        final user = doc.data();
        // Return user
        return user;
      }).toList();
    });
  }

  // Send message
  Future<void> sendMessage(String receiverId, message) async {
    // Get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp, senderUsername: 'username',
    );

    // Construct chatroom id for the 2 users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); // Sort the ids 
    String chatroomID = ids.join('_');

    // Add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct chatroom id for the 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort(); // Sort the ids
    String chatroomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get user document by email
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDetails(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  // Get user document by uid
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) async {
    return await _firestore.collection('Users').doc(uid).get();
  }

  createChatRoom(List<String> selectedUserIds) {}

  searchUsersByUsername(String searchText) {}
}
