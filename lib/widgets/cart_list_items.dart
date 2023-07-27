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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Q u a n t i t y',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Container(
            height: 40,
            width: 130,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    color: Colors.white,
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
                  child: const Card(
                    color: Colors.grey,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      count++;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        child: ListTile(
          leading: Image(
            height: 100,
            fit: BoxFit.fill,
            image: CachedNetworkImageProvider(widget.image),
          ),
          title: Text(widget.title),
          subtitle: Text('₦ ${widget.price.toDouble()}'),
          trailing: Column(
            children: [
              _buildQuantityPart(quantity: count),
            ],
          ),
        ),
      ),
    );
  }
}
