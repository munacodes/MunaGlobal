import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
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

  logout() {
    FirebaseAuth.instance.signOut();
  }

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
    if (newValue.trim().isNotEmpty) {
      // only update if there is something in the textfield
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  profileHeader() {
    // Profile pic
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              //  backgroundImage: CachedNetworkImageProvider(url),
            ),
            Positioned(
              top: 60.0,
              bottom: 5.0,
              right: 5.0,
              left: 80.0,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  buildButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 40,
        width: 150,
        child: Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Message',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // retrive profile details from firebase
  profileDetails() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('User Details')
          .doc(currentUser!.email)
          .snapshots(),
      builder: (context, snapshot) {
        // get user data
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              // user details
              children: [
                // username
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 9.0,
                  child: MyTextBox(
                    text: userData['userName'],
                    sectionName: 'username',
                    onPressed: () => editField('userName'),
                  ),
                ),

                // bio
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 9.0,
                  child: MyTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                ),
              ],
            ),
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

  // retrive posts from firebase
  profilePosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Posts')
          .orderBy('Timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 800,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index];
                  return GridTiled(
                    image: post['ImageUrl'],
                  );
                },
              ),
            ),
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
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 285,
            // color: Colors.blue,
            width: double.infinity,
            child: Column(
              children: [
                profileHeader(),
                profileDetails(),
              ],
            ),
          ),
          Row(
            children: const [
              SizedBox(width: 10),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          profilePosts(),
        ],
      ),
    );
  }
}
