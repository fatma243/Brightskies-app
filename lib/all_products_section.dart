import 'package:flutter/material.dart';
import '../product.dart';
import 'product_card.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
        imagePath: 'assets/images/car1.webp',
        title: 'Geely Galaxy L7',
        price: 22000,
        description: 'A modern electric SUV with futuristic design.',
        location: 'Cairo, Egypt',
        rating: 4.6,
        features: [
          'Electric powertrain',
          'Panoramic sunroof',
          '360-degree camera',
        ],
      ),
      Product(
        imagePath: 'assets/images/car2.jpeg',
        title: 'Mercedes-Benz G-Class',
        price: 37000,
        description: 'Luxury SUV with unmatched off-road performance.',
        location: 'Alexandria, Egypt',
        rating: 4.9,
        features: [
          'V8 Biturbo Engine',
          'Premium leather interior',
          'All-wheel drive system',
        ],
      ),
      Product(
        imagePath: 'assets/images/car5.jpeg',
        title: 'Ford Puma',
        price: 18000,
        description: 'Compact crossover with sporty styling.',
        location: 'Giza, Egypt',
        rating: 4.4,
        features: [
          'EcoBoost engine',
          'Wireless charging',
          'Smart safety features',
        ],
      ),
      Product(
        imagePath: 'assets/images/car6.jpeg',
        title: 'Hyundai Ioniq 6',
        price: 44000,
        description: 'Sleek electric sedan with high-tech interior.',
        location: 'Mansoura, Egypt',
        rating: 4.8,
        features: [
          'Long range battery',
          'Ambient lighting',
          'Touchscreen infotainment',
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "All Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.72,
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
