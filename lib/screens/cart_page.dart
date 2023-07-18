import 'package:flutter/material.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CartPage extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final double price;
  const CartPage({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double subTotal = 26;
  int tax = 100;
  int quantity = 3;
  String totalPrice = 'subTotal * tax * quantity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  name: widget.name,
                  description: widget.description,
                  price: widget.price,
                  image: widget.image,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: 500,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return CartListItem(
                price: widget.price,
                image: widget.image,
                name: widget.name,
                quantity: quantity,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Card(
        color: Colors.white,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '₦ ${widget.price.toDouble()}',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Order now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
