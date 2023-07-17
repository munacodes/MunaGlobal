import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartListItem extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  const CartListItem({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Card(
          child: ListTile(
            leading: Image(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(image),
            ),
            title: Text(name),
            subtitle: Text('₦ ${price.toDouble()}'),
            trailing: Column(
              children: const [
                Text('-'),
                Text('1'),
                Text('+'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
