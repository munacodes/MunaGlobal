import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/models/models_exports.dart';
import 'package:muna_global/screen/message_and_chat/message_export.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class SearchMessage extends StatefulWidget {
  const SearchMessage({super.key});

  @override
  State<SearchMessage> createState() => _SearchMessageState();
}

class _SearchMessageState extends State<SearchMessage> {
  TextEditingController searchController = TextEditingController();
  String searchName = '';

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MessagesPage(),
            ),
          );
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search",
          filled: true,
          prefixIcon: const Icon(Icons.search, size: 28.0),
          suffixIcon: IconButton(
            onPressed: clearSearch,
            icon: const Icon(Icons.clear),
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchName = value;
          });
        },
        //  onFieldSubmitted: handleSearch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      // put stream builder in a or container column to call both users and posts
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .orderBy('userName')
              .startAt([searchName]).endAt([searchName]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                children: const [
                  Text(
                    'Something went wrong.',
                  ),
                  Text(
                    'Check your internet Connection.',
                  ),
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(data['photoUrl']),
                  ),
                  title: Text(data['userName']),
                  subtitle: Text(data['userEmail']),
                  onTap: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ChatPage(),
                    //   ),
                    // );
                  },
                );
              },
            );
          }),
    );
  }
}

class SearchResult extends StatelessWidget {
  final UserModel user;
  const SearchResult({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.userName,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const Divider(height: 2.0, color: Colors.white54),
        ],
      ),
    );
  }
}
