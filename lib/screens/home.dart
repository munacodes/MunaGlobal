import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:muna_global/models/models_exports.dart';
import 'package:muna_global/screens/profile_page.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final GoogleSignIn googleSignIn = GoogleSignIn();
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

class _HomeState extends State<Home> {
  bool isAuth = false;

  PageController? pageController;
  int pageIndex = 0;

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    // decects when user signs in
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error siging in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error siging in: $err');
    });

    pageController = PageController();
  }

  handleSignIn(GoogleSignInAccount? account) {
    createUserInFirestore();
    if (account != null) {
      print('User signed in: $account');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database(according to their id)
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    // 2) if the user doesn't exists, then we want to take them to create account page
    if (!doc.exists) {
      final username = await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CreateAccount(),
        ),
      );

      // 3) get username from create account use it to make new doucument in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "timestamp": timestamp,
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser!.username);
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

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          //  Sales(),
          ElevatedButton(
            onPressed: logout,
            child: const Text('Logout'),
          ),
          const MessagesPage(),
          //  CartPage(),
          const UploadPage(),
          const SearchPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //  backgroundColor: Colors.blue,
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart_outlined),
          //   label: 'Cart',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.teal,
              Colors.purple,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'MunaGlobal',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Google.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
