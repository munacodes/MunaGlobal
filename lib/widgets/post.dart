import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/models/user_model.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/progress.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
