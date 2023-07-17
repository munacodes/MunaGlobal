import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class ProfileImages extends StatefulWidget {
  const ProfileImages({super.key});

  @override
  State<ProfileImages> createState() => _ProfileImagesState();
}

class _ProfileImagesState extends State<ProfileImages> {
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

  profileHeader() {
    // Profile pic
    return Column(
      children: [
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
      ],
    );
  }

  profileDetails() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .snapshots(),
      builder: (context, snapshot) {
        // get user data
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
    );
  }

  profilePosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('User Posts')
          .doc(currentUser!.email)
          .collection('Posts')
          .orderBy('TimeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // get the message
              final post = snapshot.data!.docs[index];
              return SalesProduct(
                image: post['mediaUrl'],
                likes: List<String>.from(post['Likes'] ?? []),
                message: post['Description'],
                postId: post.id,
                time: formatDate(post['TimeStamp']),
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
    );
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
      body: ListView(
        children: [
          profileHeader(),
          profileDetails(),
          profilePosts(),
        ],
      ),
    );
  }
}
