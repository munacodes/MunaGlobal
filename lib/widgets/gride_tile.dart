import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridTile extends StatefulWidget {
  final String mediaUrl;
  const GridTile({super.key, required this.mediaUrl});

  @override
  State<GridTile> createState() => _GridTileState();
}

class _GridTileState extends State<GridTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(widget.mediaUrl),
        ),
      ),
    );
  }
}
