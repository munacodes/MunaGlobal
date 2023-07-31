import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
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
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
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
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              height: 70,
                              width: 80,
                              fit: BoxFit.fill,
                              image: userData['PhotoUrl'] != null
                                  ? CachedNetworkImageProvider(
                                      userData['PhotoUrl'],
                                    )
                                  : const AssetImage(
                                          'assets/images/User Image.png')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['UserName'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userData['Bio'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.qr_code_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ],
              ),
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

  // retrive posts from firebase in grid form
  Widget gridProfilePosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Posts')
          .orderBy('Timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text(
            'No Post yet',
            style: TextStyle(color: Colors.black, fontSize: 20),
          );
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.docs[index];
                return GridTiled(
                  image: post['ImageUrl'],
                );
              },
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

  // retrive posts from firebase in list form
  Widget listProfilePosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Posts')
          .orderBy('Timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text(
            'No Post yet',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          );
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.docs[index];
                return ListTiled(
                  image: post['ImageUrl'],
                );
              },
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text(
            'No Post yet',
            style: TextStyle(color: Colors.grey, fontSize: 20),
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

  profilePost() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            child: const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.blue,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.grid_view_outlined,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.list_outlined,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                gridProfilePosts(),
                listProfilePosts(),
              ],
            ),
          ),
        ],
      ),
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
        actions: const [
          PopUpMenu(),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            child: Column(
              children: [
                profileDetails(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCountColumn("Post", postCount),
                      buildCountColumn("Followers", followerCount),
                      buildCountColumn("Following", followingCount),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 500,
            child: profilePost(),
          ),
        ],
      ),
    );
  }
}
