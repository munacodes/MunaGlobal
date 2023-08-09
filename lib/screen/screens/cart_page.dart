import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CartPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final double price;
  final String size;
  final int quantity;
  final double rating;
  final String productId;
  const CartPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.size,
    required this.quantity,
    required this.rating,
    required this.productId,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  sendOrderToFirebase(String onDelivery) async {
    await FirebaseFirestore.instance.collection('Orders').add({
      "Name Of Product": widget.title,
      "Image": widget.image,
      "Price": widget.price,
      "Size": widget.size,
      "Quantity": widget.quantity,
      "Payment Status": onDelivery,
    });
    Fluttertoast.showToast(
      msg: 'Order  Successful',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.pop(context);
  }

  Future<void> _buildShowDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'P a y m e n t',
          style: TextStyle(color: Colors.blue),
        ),
        content: Container(
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  child: Card(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'P a y   N o w',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: sendOrderToFirebase('Pay on Delivery'),
                child: Container(
                  height: 50,
                  child: Card(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'P a y   O n    D e l i v e r y',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                  productId: widget.productId,
                  rating: widget.rating,
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Carts')
                .orderBy('Timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot cartItem =
                          snapshot.data!.docs[index];

                      // double total = 0;
                      // for (var item in cartItem) {
                      //   double price = item['Price'];
                      //   int quantity = item['Quantity'];
                      //   total += price * quantity;
                      // }
                      return CartListItem(
                        title: cartItem['Name of Product'],
                        image: cartItem['ImageUrl'],
                        price: cartItem['Price'],
                        quantity: cartItem['Quantity'],
                        cartId: cartItem.id,
                        userId: cartItem.id,
                      );
                    });
              } else if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.blue,
                        size: 40,
                      ),
                      Text(
                        'No Cart Yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
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
              child: Row(
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '₦ ${widget.price.toDouble()}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _buildShowDialog();

                  // send to firebase and notifcation feed to notify the user of current order
                  // create a collection('order') and use streambuilder to stream order
                  // and notifiy the owner of the post in notification feeds
                },
                child: const Text('Order  All  now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
