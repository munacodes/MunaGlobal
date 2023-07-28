import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                  .doc('51wxceGUFmAS1I4yT2A1')
                  .update({
                'Quantity': FieldValue.increment(-1),
              });
            });
          },
          child: const Icon(
            Icons.remove,
            color: Colors.grey,
          ),
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              count++;
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.email)
                  .collection('Carts')
                  .doc('51wxceGUFmAS1I4yT2A1')
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.image),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title),
                        Text('₦ ${widget.price.toDouble()}'),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Order Now'),
                        ),
                      ],
                    ),
                    _buildQuantityPart(quantity: count),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemCart extends StatefulWidget {
  final String image;
  final String title;
  final double price;
  final int quantity;
  const ItemCart(
      {super.key,
      required this.image,
      required this.title,
      required this.price,
      required this.quantity});

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
              spreadRadius: 1.0,
              color: Colors.grey[400]!,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title),
                const SizedBox(height: 10),
                Text('₦ ${widget.price.toDouble()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
