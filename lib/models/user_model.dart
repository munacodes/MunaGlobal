import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  //final String bio;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    // required this.bio,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      // bio: doc['bio'],
    );
  }
}
