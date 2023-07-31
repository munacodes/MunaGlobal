import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final DateTime timestamp = DateTime.now();

  // display a dialog message
  void displayMessage(String message, {required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  // Google sign in
  signInWithGoogle({required BuildContext context}) async {
    // begin interactive sign in process
    final GoogleSignInAccount? googleCurrentUser =
        await GoogleSignIn().signIn();

    // Obtain auth details from request
    final GoogleSignInAuthentication gAuth =
        await googleCurrentUser!.authentication;

    // create a new credential for user
    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      // after creating the user, create a new document in cloud firestore called Users
      FirebaseFirestore.instance
          .collection('Users')
          .doc(googleCurrentUser.email)
          .collection('User Details')
          .doc(googleCurrentUser.email)
          .set({
        // Using split '@'[0] tells it to split the email where
        //there is '@' which is index [0] and use it as a username
        'UserName': googleCurrentUser.email.split('@')[0], // initial username
        'Bio': 'Empty bio...', // initially empty bio
        "UserId": googleCurrentUser.id,
        "PhotoUrl": googleCurrentUser.photoUrl,
        "UserEmail": googleCurrentUser.email,
        "DisplayName": googleCurrentUser.email.split('@')[0],
        "Timestamp": timestamp,
      });

      // finally, lets sign in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // pop loading circle

      if (context.mounted) Navigator.pop(context);
      // display error message
      displayMessage(
        e.code,
        context: context,
      );
    }
  }
}
