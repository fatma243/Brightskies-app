import 'package:flutter/material.dart';
import 'featured_section.dart';
import 'categories_section.dart';
import 'all_products_section.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "E-commerce",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
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