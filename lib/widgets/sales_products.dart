import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muna_global/screen/message_and_chat/message_export.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:uuid/uuid.dart';

class SalesProduct extends StatefulWidget {
  final String photoUrl;
  final String location;
  final String description;
  final String title;
  final String image;
  final String userEmail;
  final String time;
  final double price;
  final String postId;
  final String size;
  final int quantity;
  final List<String> likes;
  final String cartId;
  final String userId;
  final double rating;
  const SalesProduct({
    super.key,
    required this.description,
    required this.time,
    required this.postId,
    required this.likes,
    required this.image,
    required this.price,
    required this.title,
    required this.userEmail,
    required this.location,
    required this.size,
    required this.quantity,
    required this.photoUrl,
    required this.cartId,
    required this.userId,
    required this.rating,
  });

  @override
  State<SalesProduct> createState() => _SalesProductState();
}

class _SalesProductState extends State<SalesProduct> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  bool showHeart = false;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
    isTapped;
  }

  // toggle like
  void toggled() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document is Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the 'likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  void addToCart() {
    setState(() {
      isTapped = !isTapped;
    });

    if (isTapped) {
      FirebaseFirestore.instance.collection('Carts').add({
        "Name of Product": widget.title,
        "ImageUrl": widget.image,
        "Price": widget.price,
        "Size": widget.size,
        "Description": widget.description,
        "Quantity": widget.quantity,
        "Timestamp": Timestamp.now(),
      });
      Fluttertoast.showToast(
        msg: 'Added  to  cart',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (!isTapped) {
      FirebaseFirestore.instance
          .collection('Carts')
          .doc(widget.cartId)
          .delete();
      Fluttertoast.showToast(
        msg: 'Removed  from  cart',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[300],
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  // product image
                  Container(
                    height: 130,
                    width: 140,
                    child: GestureDetector(
                      onDoubleTap: toggled,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              postId: widget.postId,
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(widget.image),
                              ),
                            ),
                          ),
                          showHeart
                              ? Animator(
                                  duration: const Duration(milliseconds: 300),
                                  tween: Tween(begin: 0.8, end: 1.4),
                                  curve: Curves.elasticOut,
                                  cycles: 0,
                                  builder: (context, animatorState, child) =>
                                      Transform.scale(
                                    scale: animatorState.value,
                                    child: const Icon(Icons.favorite,
                                        size: 80.0, color: Colors.red),
                                  ),
                                )
                              : const Text(''),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              backgroundImage: widget.photoUrl != null
                                  ? CachedNetworkImageProvider(
                                      widget.photoUrl.toString())
                                  : const AssetImage(
                                          'assets/images/User Image.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.userEmail.toString(),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // name of product
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  // color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Text(widget.location),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₦ ${widget.price.toDouble()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            // time
                            Text(
                              widget.time,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text(
                              '.',
                              style: TextStyle(fontSize: 10),
                            ),
                            // like button
                            LikeButton(
                              isLiked: isLiked,
                              onTap: toggled,
                            ),
                            const Text(
                              '.',
                              style: TextStyle(fontSize: 10),
                            ),

                            // like count
                            Text(
                              widget.likes.length.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                              alignment: Alignment.bottomLeft,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      receiverUserName: widget.userEmail,
                                      receiverUserID: widget.userId,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.question_answer_outlined,
                                size: 35,
                              ),
                            ),
                            const Text(
                              'Chat',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.phone_outlined),
                            ),
                            const Text(
                              'Call',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text(
                              '.',
                              style: TextStyle(fontSize: 10),
                            ),
                            CartButton(
                              isTapped: isTapped,
                              onTap: addToCart,
                            ),
                            const Text(
                              '.',
                              style: TextStyle(fontSize: 5),
                            ),
                            const Text(
                              'Add to cart',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
