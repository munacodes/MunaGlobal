import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:muna_global/screens/profile_page.dart';
import 'package:muna_global/screens/screens_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final auth = FirebaseAuth.instance.currentUser;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final messageRef = FirebaseFirestore.instance.collection('messages');
final postRef = FirebaseFirestore.instance.collection('posts');
final notificationsFeedRef =
    FirebaseFirestore.instance.collection('notifications');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followeringRef = FirebaseFirestore.instance.collection('following');
final contactUsRef = FirebaseFirestore.instance.collection('contact us');
// final commentsRef = FirebaseFirestore.instance.collection('comments');
final DateTime timestamp = DateTime.now();
User? currentUser;

class _HomePageState extends State<HomePage> {
  PageController? pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController!.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Sales(),
          MessagesPage(),
          CartPage(),
          SearchPage(),
          // UploadPage(currentUser: currentUser),
          ProfilePage(),
          // ProfileScreeen(profileId: auth?.uid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.shifting,
        currentIndex: pageIndex,
        onTap: onTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sell_outlined),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.camera),
          //   label: 'Upload',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
