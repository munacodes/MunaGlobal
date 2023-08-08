import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:uuid/uuid.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final double price;
  final String size;
  final int quantity;
  final double rating;
  final String productId;
  const DetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.size,
    required this.quantity,
    required this.rating,
    required this.productId,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  bool _isTapped = false;
  String cartId = const Uuid().v4();
  final bool _hasSize = false;
  double _isRated = 0;

  @override
  void initState() {
    super.initState();
    _hasSize;
    _isTapped;
    getRatingIndex();
  }

  void addToCart() {
    setState(() {
      _isTapped = !_isTapped;
    });

    if (_isTapped) {
      FirebaseFirestore.instance.collection('Carts').add({
        "Name of Product": widget.title,
        "ImageUrl": widget.image,
        "Price": widget.price,
        "cartId": cartId,
        "Size": widget.size,
        "Quantity": widget.quantity,
        "Description": widget.description,
        "Timestamp": Timestamp.now(),
      });
      Fluttertoast.showToast(
        msg: 'Added  to  cart',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CartPage(
            productId: widget.productId,
            rating: widget.rating,
            title: widget.title,
            description: widget.description,
            image: widget.image,
            price: widget.price,
            size: widget.size,
            quantity: widget.quantity,
          ),
        ),
      );
    }
  }

  getRatingIndex() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Products').get();
    setState(() {
      _isRated = snapshot.docs.length.toDouble();
    });
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
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) => const Explore(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    productId: widget.productId,
                    rating: widget.rating,
                    title: widget.title,
                    price: widget.price,
                    image: widget.image,
                    description: widget.description,
                    quantity: widget.quantity,
                    size: widget.size,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
          ),
        ],
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
          height: 300,
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
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 35.0,
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
                  height: 50,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.description,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RatingBar.builder(
                  maxRating: 5,
                  minRating: 0,
                  initialRating: _isRated,
                  allowHalfRating: true,
                  itemSize: 40,
                  updateOnDrag: true,
                  itemPadding: const EdgeInsets.all(5.0),
                  itemCount: 5,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('Products')
                          .doc(widget.productId)
                          .update({
                        'Rating': value,
                      });
                    });
                  },
                ),
                const SizedBox(height: 10),
                _hasSize != null
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Size: ',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                widget.size.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '₦ ${widget.price.toDouble()}',
                        overflow: TextOverflow.ellipsis,
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
