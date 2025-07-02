import 'package:flutter/material.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "All Products",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildProductCard('assets/images/car1.webp', '123', 22000.0),
            _buildProductCard('assets/images/car2.jpeg', '345', 37000.0),
            _buildProductCard('assets/images/car5.jpeg', '567', 18000.0),
            _buildProductCard('assets/images/car6.jpeg', '789', 44000.0),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(String imagePath, String title, double price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}