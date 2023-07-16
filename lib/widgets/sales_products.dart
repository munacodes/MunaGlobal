import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class SalesProduct extends StatefulWidget {
  final String message;
  final String image;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const SalesProduct(
      {super.key,
      required this.message,
      required this.user,
      required this.time,
      required this.postId,
      required this.likes,
      required this.image});

  @override
  State<SalesProduct> createState() => _SalesProductState();
}

class _SalesProductState extends State<SalesProduct> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  // toggle like
  void toggled() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document is Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user
          Row(
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                '.',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                widget.time,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),

          // product
          Container(
            decoration: const BoxDecoration(
              // image: DecorationImage(),
              color: Colors.blue,
            ),
          ),

          // like button + like count + cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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

              // shopping cart
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
