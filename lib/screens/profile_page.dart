import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/models/models_exports.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser;
  // all users
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  // edit field
  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          // save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    // update in firestore
    if (newValue.trim().length > 0) {
      // only update if there is something in the textfield
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        // centerTitle: true,
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(height: 10),

                // Profile pic
                const Icon(
                  Icons.person,
                  size: 52,
                ),

                const SizedBox(height: 10),

                // user email
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 20),

                // user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // username
                Card(
                  child: MyTextBox(
                    text: userData['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),
                ),

                // bio
                Card(
                  child: MyTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                ),
                const SizedBox(height: 20),

                const Divider(thickness: 0.9),

                const SizedBox(height: 20),

                // user posts

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Post',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  profileDetails() {}

  retrivePostsFromFirebase() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User Posts')
            .doc(currentUser!.email)
            .collection('Posts')
            .orderBy('Timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // get the message
                final post = snapshot.data!.docs[index];
                return SalesProduct(
                  name: post['Name of Product'],
                  image: post['mediaUrl'],
                  likes: List<String>.from(post['Likes'] ?? []),
                  description: post['Description'],
                  price: post['Price'],
                  postId: post.id,
                  time: formatDate(post['Timestamp']),
                  user: post['UserEmail'],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
