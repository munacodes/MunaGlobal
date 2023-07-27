import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:uuid/uuid.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final double price;

  const DetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  bool isTapped = false;
  String cartId = const Uuid().v4();

  void addToCart() {
    setState(() {
      isTapped = !isTapped;
    });

    if (isTapped) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Carts')
          .add({
        "Name of Product": widget.title,
        "mediaUrl": widget.image,
        "Price": widget.price,
        "cartId": cartId,
        "Description": widget.description,
        "Timesatmp": Timestamp.now(),
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CartPage(
            title: widget.title,
            description: widget.description,
            image: widget.image,
            price: widget.price,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 280.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(widget.image),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          height: 350,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.description,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Size: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '42 or XL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '₦ ${widget.price.toDouble()}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.blue,
                        elevation: 10,
                        child: Container(
                          height: 40,
                          width: 150,
                          child: GestureDetector(
                            onTap: addToCart,
                            child: const Center(
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     elevation: MaterialStateProperty(12),
                      //   ),
                      //   onPressed: () {
                      //     Navigator.of(context).pushReplacement(
                      //       MaterialPageRoute(
                      //         builder: (context) => CartListItem(
                      //           name: widget.name,
                      //           quantity: count,
                      //           price: widget.price,
                      //           image: widget.image,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text('Add to Cart'),
                      // ),
                    ),
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
