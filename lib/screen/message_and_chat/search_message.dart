import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final searchController = TextEditingController();
  Future<QuerySnapshot<Object>>? searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot<Object>> users = FirebaseFirestore.instance
        .collection('Users')
        .where('userName', isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  Container buildNoContent() {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
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
        List<SearchResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          UserModel user = UserModel.fromDocument(doc);
          SearchResult searchResult = SearchResult(user: user);
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
      appBar: AppBar(
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
          onFieldSubmitted: handleSearch,
        ),
      ),
      body: SafeArea(
        child: searchResultsFuture == null
            ? buildNoContent()
            : buildSearchResults(),
      ),
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
