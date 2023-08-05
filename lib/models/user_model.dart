import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   final String uid;
//   final String userName;
//   final String userEmail;
//   final String photoUrl;
//   final String displayName;
//   final String bio;

//   const UserModel({
//     required this.uid,
//     required this.userName,
//     required this.userEmail,
//     required this.photoUrl,
//     required this.displayName,
//     required this.bio,
//   });

//   factory UserModel.fromJson(DocumentSnapshot doc) {
//     return UserModel(
//       uid: doc['uid'],
//       userEmail: doc['userEmail'],
//       userName: doc['userName'],
//       photoUrl: doc['photoUrl'],
//       displayName: doc['displayName'],
//       bio: doc['bio'],
//     );
//   }
// }

class UserModel {
  final String uid;
  final String userName;
  final String userEmail;
  final String photoUrl;
  final String bio;

  const UserModel({
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.photoUrl,
    required this.bio,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['UserId'],
      userEmail: doc['UserEmail'],
      userName: doc['UserName'],
      photoUrl: doc['PhotoUrl'],
      bio: doc['Bio'],
    );
  }
}
