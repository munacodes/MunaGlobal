import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategorySingleItem extends StatelessWidget {
  final String name;
  final String image;
  const CategorySingleItem(
      {super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Column(
        children: [
          Text(name),
          Image(
            image: CachedNetworkImageProvider(image),
          ),
        ],
      ),
    );
  }
}
