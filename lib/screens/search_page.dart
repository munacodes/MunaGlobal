import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/models/user_model.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot<Object>>? searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot<Object>> product = FirebaseFirestore.instance
        .collection('User Posts')
        .where('Name of Product', isGreaterThanOrEqualTo: query)
        .get();
    Future<QuerySnapshot<Object>> users = FirebaseFirestore.instance
        .collection('Users')
        .where('userName', isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;
      searchResultsFuture = product;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
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
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Container buildNoContent() {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Image(
            //   image: const AssetImage('assets/images/search.png'),
            //   height: orientation == Orientation.portrait ? 300.0 : 150.0,
            // ),
            Text(
              'Search',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[300],
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    FutureBuilder(
      future: searchResultsFuture!,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user: user);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;
  const UserResult({super.key, required this.user});

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
                user.username,
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
