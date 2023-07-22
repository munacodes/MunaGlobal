import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridTiled extends StatefulWidget {
  final String image;
  const GridTiled({super.key, required this.image});

  @override
  State<GridTiled> createState() => _GridTiledState();
}

class _GridTiledState extends State<GridTiled> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      elevation: 10.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          image: DecorationImage(
            alignment: Alignment.center,
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(widget.image),
          ),
        ),
      ),
    );
  }
}
