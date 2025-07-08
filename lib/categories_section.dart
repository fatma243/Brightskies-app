import 'package:flutter/material.dart';

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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
