import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridTiled extends StatelessWidget {
  final String image;
  const GridTiled({super.key, required this.image});

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
            fit: BoxFit.fill,
            image: CachedNetworkImageProvider(image),
          ),
        ),
      ),
    );
  }
}

class ListTiled extends StatelessWidget {
  final String image;
  const ListTiled({super.key, required this.image});

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
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          image: DecorationImage(
            alignment: Alignment.center,
            fit: BoxFit.fill,
            image: CachedNetworkImageProvider(image),
          ),
        ),
      ),
    );
  }
}
