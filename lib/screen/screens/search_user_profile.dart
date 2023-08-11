import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/models/user_model.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String searchName = '';

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop(
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search...",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      // put stream builder in a  container or column to call both users and their recent posts
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      if (searchName.isEmpty ||
                          searchName != currentUser!.email ||
                          currentUser!.email != data['UserName']) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: data['PhotoUrl'] != null
                                ? CachedNetworkImageProvider(data['PhotoUrl'])
                                : const AssetImage(
                                        'assets/images/User Image.png')
                                    as ImageProvider,
                          ),
                          title: Text(
                            data['UserName'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            data['UserEmail'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        );
                      }
                      if (data['UserName'] !=
                          currentUser!.email
                              .toString()
                              .toLowerCase()
                              .startsWith(searchName.toLowerCase())) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                CachedNetworkImageProvider(data['PhotoUrl']),
                          ),
                          title: Text(
                            data['UserName'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            data['UserEmail'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  );
          }),
    );
  }
}
