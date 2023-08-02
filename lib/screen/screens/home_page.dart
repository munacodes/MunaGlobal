import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/screen/category/category_exports.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final currentUser = FirebaseAuth.instance.currentUser;

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = const [
    Explore(),
    CategoryPage(),
    UploadPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.explore,
                      color: Colors.blue,
                      size: 30,
                    )
                  : const Icon(
                      Icons.explore_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.category,
                      color: Colors.blue,
                      size: 30,
                    )
                  : const Icon(
                      Icons.category_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.add_box,
                      color: Colors.blue,
                      size: 30,
                    )
                  : const Icon(
                      Icons.add_box_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.search,
                      color: Colors.blue,
                      size: 30,
                    )
                  : const Icon(
                      Icons.search_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              icon: pageIndex == 4
                  ? const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    )
                  : const Icon(
                      Icons.person_outline_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
