import 'package:flutter/material.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key});

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
