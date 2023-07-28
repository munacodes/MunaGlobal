import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CartPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final double price;
  final String size;
  final int quantity;
  const CartPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.size,
    required this.quantity,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  // double subTotal = 26;
  // int tax = 100;
  // int quantity = 3;
  // String totalPrice = 'subTotal * tax * quantity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  title: widget.title,
                  description: widget.description,
                  price: widget.price,
                  image: widget.image,
                  size: widget.size,
                  quantity: widget.quantity,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 470,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUser!.email)
                      .collection('Carts')
                      .orderBy('Timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final cartItem = snapshot.data!.docs[index];
                            return CartListItem(
                              title: cartItem['Name of Product'],
                              image: cartItem['ImageUrl'],
                              price: cartItem['Price'],
                              quantity: cartItem['Quantity'],
                            );
                          });
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'No Cart Yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.blue,
                child: const Center(
                  child: Text('SubTotal and tax'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Card(
        color: Colors.white,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '₦ ${widget.price.toDouble()}',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // send to firebase and notifcation feed to notify the user of current order
                  // create a collection('order') and use streambuilder to stream order
                  // and notifiy the owner of the post in notification feeds
                },
                child: const Text('Order now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
