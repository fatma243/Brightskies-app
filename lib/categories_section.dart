import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

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
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 16),
              Image.asset('assets/images/car1.webp', width: 160),
              const SizedBox(width: 16),
              Image.asset('assets/images/car2.jpeg', width: 160),
              const SizedBox(width: 16),
              Image.asset('assets/images/car3.jpeg', width: 160),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}