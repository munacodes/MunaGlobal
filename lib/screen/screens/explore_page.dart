import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/screen/message_and_chat/message_export.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Explore',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        actions: [
          Container(
            width: 80,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // the sales using Streambuilder to retrive info from firebase and display here

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .orderBy('Timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // get the message
                      final product = snapshot.data!.docs[index];
                      return SalesProduct(
                        rating: product['Rating'].toDouble(),
                        location: product['Location'],
                        photoUrl: product['PhotoUrl'],
                        image: product['ImageUrl'],
                        title: product['Name of Product'],
                        likes: List<String>.from(product['Likes'] ?? []),
                        description: product['Description'],
                        price: product['Price'].toDouble(),
                        userId: currentUser.uid,
                        productId: product.id,
                        cartId: product.id,
                        time: formatDate(product['Timestamp']),
                        userEmail: product['UserEmail'],
                        size: product['Size'],
                        quantity: int.parse(product['Quantity']),
                      );
                    },
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No Product yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: const [
                        Text(
                          'Something went wrong',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Pleast try again later',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
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
