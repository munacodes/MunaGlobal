import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Sales',
          style: TextStyle(fontSize: 40.0),
        ),
        actions: [
          IconButton(
            onPressed: () {
              const NotificationFeed();
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Sales'),
          ),
          ElevatedButton(
            onPressed: logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
