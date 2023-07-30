import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muna_global/screen/screens/profile_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;
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
    Fluttertoast.showToast(
      msg: 'Updated  Successfully',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );

    // update in firestore
    if (newValue.trim().isNotEmpty) {
      // only update if there is something in the textfield
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        elevation: 0.0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser!.email)
              .collection('User Details')
              .doc(currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            final userData = snapshot.data!.data()!;
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(
                                        userData['photoUrl']),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 240, top: 100),
                              child: Card(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.grey),
                          title: Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          subtitle: Text(
                            userData['userName'],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              // editField();
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          leading:
                              const Icon(Icons.dangerous, color: Colors.grey),
                          title: Text(
                            'Bio',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          subtitle: Text(
                            userData['bio'],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              // editField();
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.grey),
                          title: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          subtitle: Text(
                            userData['userEmail'],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
      ),
    );
  }
}
