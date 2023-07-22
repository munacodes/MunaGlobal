import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartListItem extends StatefulWidget {
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
  State<CartListItem> createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        child: ListTile(
          leading: Image(
            height: 100,
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(widget.image),
          ),
          title: Text(widget.name),
          subtitle: Text('₦ ${widget.price.toDouble()}'),
          trailing: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.close),
              ),
              Row(
                children: [
                  Text('Quantity: ${widget.quantity}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
