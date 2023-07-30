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
      title: TextFormField(
        controller: searchController,
        autofocus: true,
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser!.email)
              .collection('User Details')
              .orderBy('userName')
              .startAt([searchName]).endAt(["$searchName\uf8ff"]).snapshots(),
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
