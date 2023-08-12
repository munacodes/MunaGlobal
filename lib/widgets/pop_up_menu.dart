import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    logout() {
      FirebaseAuth.instance.signOut();
      // navigatr to login
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PopupMenuButton(
        child: const Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Contact Us',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Share',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'About Us',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: logout,
              child: const Text(
                'LogOut',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
