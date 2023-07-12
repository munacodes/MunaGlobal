import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationFeed extends StatefulWidget {
  const NotificationFeed({super.key});

  @override
  State<NotificationFeed> createState() => _NotificationFeedState();
}

class _NotificationFeedState extends State<NotificationFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Notification"),
      body: SafeArea(
        child: Container(
          color: Colors.white54,
        ),
      ),
    );
  }
}

class NotificationFeedItem extends StatelessWidget {
  const NotificationFeedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
      ),
    );
  }
}
