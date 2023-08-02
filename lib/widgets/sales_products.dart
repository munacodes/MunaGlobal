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
  final String userName;
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
    required this.userName,
    required this.size,
    required this.quantity,
    required this.photoUrl,
    required this.cartId,
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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // user
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.photoUrl != null
                              ? CachedNetworkImageProvider(
                                  widget.photoUrl.toString())
                              : const AssetImage('assets/images/User Image.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.userName.toString(),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    // time
                    Text(
                      widget.time,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 10),

                // product image
                GestureDetector(
                  onDoubleTap: toggled,
                  onTap: () {
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 220.0,
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
                const SizedBox(height: 10),

                // price
                Text(
                  '₦ ${widget.price.toDouble()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                // like button + like count + cart
                ListTile(
                  leading: Column(
                    children: [
                      // like button
                      LikeButton(
                        isLiked: isLiked,
                        onTap: toggled,
                      ),

                      const SizedBox(width: 10),

                      // like count
                      Text(
                        widget.likes.length.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  title: IconButton(
                    alignment: Alignment.bottomLeft,
                    onPressed: () {
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) => ChatPage(
                      //       receiverUserName: widget.userEmail,
                      //       receiverUserID: widget.userId,
                      //     ),
                      //   ),
                      // );
                    },
                    icon: const Icon(
                      Icons.question_answer_outlined,
                      size: 35,
                    ),
                  ),
                  // shopping cart
                  trailing: CartButton(
                    isTapped: isTapped,
                    onTap: addToCart,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
