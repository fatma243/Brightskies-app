import 'package:flutter/material.dart';
import '../../../product.dart';
import '../../../product_card.dart';
import 'package:my_app/commonui/title_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "E-commerce",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeaturedSection(),
              CategoriesSection(),
              ProductsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  final String featuredImage = 'assets/images/car1.webp';
  final String title = 'Top Deals on Electric Cars';
  final String subtitle = 'Details on the cars......';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const SectionTitle(text: "Featured"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            child: Stack(
              children: [
                Image.asset(
                  featuredImage,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white.withOpacity(0.8), // Semi-transparent white
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  final List<Map<String, String>> categories = const [
    {
      'image': 'assets/images/car1.webp',
      'label': 'Sport',
    },
    {
      'image': 'assets/images/car2.jpeg',
      'label': 'Luxury',
    },
    {
      'image': 'assets/images/car3.jpeg',
      'label': 'Classic',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const SectionTitle(text: "Categories"),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Column(
                children: [
                  Material(
                    elevation: 3,
                    shape: const CircleBorder(),
                    shadowColor: Colors.black26,
                    child: ClipOval(
                      child: Image.asset(
                        category['image']!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['label']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
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
        const SectionTitle(text: "All Products"),
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