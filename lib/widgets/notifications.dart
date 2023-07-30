import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationFeed extends StatefulWidget {
  const NotificationFeed({super.key});

  @override
  State<NotificationFeed> createState() => _NotificationFeedState();
}

class _NotificationFeedState extends State<NotificationFeed> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Notification',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser!.email)
              .collection('Posts')
              .orderBy('Likes', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final notification = snapshot.data!.docs[index];
                  return NotificationFeedItem(
                    mediaUrl: notification['mediaUrl'],
                    userName: notification['UserName'],
                    time: formatTime(notification['Timestamp']),
                  );
                },
              );
            } else {
              Text(
                'No Notification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0,
                ),
              );
            }
            return Center(
              child: circularProgress(),
            );
          },
        ),
      ),
    );
  }
}

class NotificationFeedItem extends StatelessWidget {
  final String mediaUrl;
  final String userName;
  final String time;
  const NotificationFeedItem(
      {super.key,
      required this.mediaUrl,
      required this.userName,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[400],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '$userName liked your product.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              time,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Container(
              height: 100,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
