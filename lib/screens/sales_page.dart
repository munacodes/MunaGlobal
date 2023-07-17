import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Explore',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.black),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // the sales using Streambuilder to retrive info from firebase and display here

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(currentUser.email)
                  .collection('Posts')
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // get the message
                      final post = snapshot.data!.docs[index];
                      return SalesProduct(
                        image: post['mediaUrl'],
                        likes: List<String>.from(post['Likes'] ?? []),
                        message: post['Description'],
                        postId: post.id,
                        time: formatDate(post['TimeStamp']),
                        user: post['UserEmail'],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
