import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartListItem extends StatefulWidget {
  final String image;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  State<CartListItem> createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  int count = 1;

  Widget _buildQuantityPart({required int quantity}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (count > 1) {
                count--;
              }
            });
          },
          child: const Icon(
            Icons.remove,
            color: Colors.grey,
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              count++;
            });
          },
          child: const Card(
            color: Colors.blue,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 120,
        child: Card(
          elevation: 5.0,
          child: ListTile(
            leading: Container(
              height: 100,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.image),
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title),
                  Text('₦ ${widget.price.toDouble()}'),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
            trailing: _buildQuantityPart(quantity: count),
          ),
        ),
      ),
    );
  }
}
