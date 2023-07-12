import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:muna_global/models/user_model.dart';

class Comments extends StatefulWidget {
  // final String saleId;
  // final String postOwnerId;
  // final String postMediaUrl;

  const Comments({
    super.key,
    // required this.saleId,
    // required this.postOwnerId,
    // required this.postMediaUrl
  });

  @override
  State<Comments> createState() => _CommentsState(
      // saleId: this.saleId,
      // postOwnerId: this.postOwnerId,
      // postMediaUrl: this.postMediaUrl,
      );
}

class _CommentsState extends State<Comments> {
  // TextEditingController commentController = TextEditingController();
  // final String saleId;
  // final String postOwnerId;
  // final String postMediaUrl;

  _CommentsState(
      // {
      //   required this.saleId,
      // required this.postOwnerId,
      // required this.postMediaUrl
      // }
      );

  // buildComments() {
  //   return StreamBuilder(
  //     stream: commentsRef
  //         .doc(saleId)
  //         .collection('comments')
  //         .orderBy('timestamp', descending: false)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return circularProgress();
  //       }
  //       List<Comment> comments = [];
  //       snapshot.data!.docs.forEach((doc) {
  //         comments.add(Comment.fromDocument(doc));
  //       });
  //       return ListView(
  //         children: comments,
  //       );
  //     },
  //   );
  // }

  // addComment() {
  //   commentsRef.doc(saleId).collection('comments').add({
  //     "username": currentUser!.username,
  //     "comment": commentController.text,
  //     "timestamp": timestamp,
  //     "avatarUrl": currentUser!.photoUrl,
  //     "userId": currentUser!.id,
  //   });
  //   bool isNotPostOwner = postOwnerId != currentUser!.id;
  //   if (isNotPostOwner) {
  //     notificationsFeedRef
  //         .doc(postOwnerId)
  //         .collection('notificationItems')
  //         .add({
  //       "type": "comment",
  //       "commentData": commentController.text,
  //       "username": currentUser!.username,
  //       "userId": currentUser!.id,
  //       "userProfileImg": currentUser!.photoUrl,
  //       "postId": postId,
  //       "mediaUrl": postMediaUrl,
  //       "timestamp": timestamp,
  //     });
  //   }
  //   commentController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );

    //  Column(
    //   children: [
    //     Expanded(child: buildComments()),
    //     const Divider(),
    //     ListTile(
    //       title: TextFormField(
    //         controller: commentController,
    //         decoration: const InputDecoration(
    //           labelText: 'Write a comment...',
    //         ),
    //       ),
    //       trailing: OutlinedButton(
    //         onPressed: addComment,
    //         child: const Text('Comment'),
    //       ),
    //     ),
    //   ],
    // ),
  }
}

class Comment extends StatelessWidget {
  // final String username;
  // final String userId;
  // final String avatarUrl;
  // final String comment;
  // final Timestamp timestamp;
  const Comment({
    super.key,
    // required this.username,
    // required this.userId,
    // required this.avatarUrl,
    // required this.comment,
    // required this.timestamp
  });

  // factory Comment.fromDocument(DocumentSnapshot doc) {
  //   return Comment(
  //     username: doc['username'],
  //     userId: doc['userId'],
  //     avatarUrl: doc['avatarUrl'],
  //     comment: doc['comment'],
  //     timestamp: doc['timestamp'],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
    // Column(
    //   children: [
    //     ListTile(
    //       title: Text(comment),
    //       leading: CircleAvatar(
    //         backgroundImage: CachedNetworkImageProvider(avatarUrl),
    //       ),
    //       subtitle: Text(timeago.format(timestamp.toDate())),
    //     ),
    //     const Divider(),
    //   ],
    // );
  }
}
