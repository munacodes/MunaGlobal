import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final bool isTapped;
  final Function()? onTap;
  const CartButton({super.key, required this.isTapped, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isTapped ? Icons.shopping_cart_outlined : Icons.shopping_cart_outlined,
        size: 30,
        color: isTapped ? Colors.blue : Colors.grey,
      ),
    );
  }
}
