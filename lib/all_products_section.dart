import 'package:flutter/material.dart';
import '../product.dart';
import 'product_card.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(imagePath: 'assets/images/car1.webp', title: '123', price: 22000),
      Product(imagePath: 'assets/images/car2.jpeg', title: '345', price: 37000),
      Product(imagePath: 'assets/images/car5.jpeg', title: '567', price: 18000),
      Product(imagePath: 'assets/images/car6.jpeg', title: '789', price: 44000),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "All Products",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: products
              .map((product) => ProductCard(product: product))
              .toList(),
        ),
      ],
    );
  }
}
