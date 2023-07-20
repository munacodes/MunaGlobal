import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartListItem extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final int quantity;
  const CartListItem({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListTile(
          leading: Image(
            height: 100,
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(image),
          ),
          title: Text(name),
          subtitle: Text('₦ ${price.toDouble()}'),
          trailing: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.close),
              ),
              Row(
                children: [
                  Text('Quantity: $quantity'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
