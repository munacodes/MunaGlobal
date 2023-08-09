import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/models/models_exports.dart';

class ChatService extends ChangeNotifier {
  // get instance of the auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSEGE
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final String currentUserPhoto =
        _firebaseAuth.currentUser!.photoURL.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      photoUrl: currentUserPhoto,
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join(
        "_"); // combines the ids into a single string to use as a chatroomID

    // add new user message to database
    await _firestore
        .collection('Messages')
        .doc(chatRoomId)
        .collection('Chat Room')
        .add(newMessage.toMap());
  }

  // GET MESSAGE
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    // construct chat room id room user ids (sorted to ensure it matched the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('Messages')
        .doc(chatRoomId)
        .collection('Chat Room')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
