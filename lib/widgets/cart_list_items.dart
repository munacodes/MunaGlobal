import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CartListItem extends StatefulWidget {
  final String image;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  State<CartListItem> createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String cartId = const Uuid().v4();
  int count = 1;

  sendOrderToFirebase(String onDelivery) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .collection('Orders')
        .add({
      "Name Of Product": widget.title,
      "Image": widget.image,
      "Price": widget.price,
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
                onTap: sendOrderToFirebase('Pay On Delivery'),
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

  Widget _buildCount() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.email)
            .collection('Carts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              widget.quantity.toString(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return Text(widget.quantity.toString());
        });
  }

  Widget _buildQuantityPart({required int quantity}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (count > 1) {
                count--;
              }
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.email)
                  .collection('Carts')
                  .doc()
                  .update({
                'Quantity': FieldValue.increment(-1),
              });
            });
          },
          child: Card(
            color: Colors.grey[400],
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildCount(),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              count++;
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.email)
                  .collection('Carts')
                  .doc()
                  .update({
                'Quantity': FieldValue.increment(1),
              });
            });
          },
          child: const Card(
            color: Colors.blue,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.email)
                  .collection('Carts')
                  .doc()
                  .delete();
              Fluttertoast.showToast(
                msg: 'Cart  deleted',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
              );
            }),
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.email)
                  .collection('Carts')
                  .doc()
                  .delete();
              Fluttertoast.showToast(
                msg: 'Cart  deleted',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
              );
            }),
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Card(
        color: Colors.grey[200],
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(widget.image),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₦ ${widget.price.toDouble()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _buildShowDialog,
                            child: const Text('Order Now'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              _buildQuantityPart(quantity: count),
            ],
          ),
        ),
      ),
    );
  }
}
