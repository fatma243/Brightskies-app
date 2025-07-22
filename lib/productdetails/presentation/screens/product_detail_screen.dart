import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appservice/product.dart';
import '../../../appservice/cart_bloc.dart';
import '../../../appservice/cart_event.dart';
import '../../../appservice/cart_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSizeIndex = 0;
  int _selectedColorIndex = 0;

  final List<String> sizes = ["160×200", "180×200", "200×200", "220×220"];
  final List<Color> colors = [
    Color(0xFFB8C79C),
    Color(0xFFE8BFF2),
    Color(0xFF9CA4E9),
  ];

  String _getColorName(Color color) {
    if (color.value == Color(0xFFB8C79C).value) return "Green";
    if (color.value == Color(0xFFE8BFF2).value) return "Pink";
    if (color.value == Color(0xFF9CA4E9).value) return "Blue";
    return "Color";
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.images.isNotEmpty) Image.network(
                  product.images[0],
                  width: screenWidth,
                  height: 346,
                  fit: BoxFit.cover,
                ) else Container(
                  width: screenWidth,
                  height: 346,
                  color: Colors.grey[300],
                  child: const Center(child: Text("No Image")),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,

                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.favorite_border,
                                  size: 20, color: Color(0xFF0019FF)),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("€ ${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Text(product.description,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 20),
                      const Text("Size",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        children: List.generate(sizes.length, (index) {
                          final selected = _selectedSizeIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSizeIndex = index;
                              });
                            },
                            child: Container(
                              width: 72,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected
                                    ? Color(0xFF0019FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? Color(0xFF0019FF)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                sizes[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      const Text("Color",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(colors.length, (index) {
                          final isSelected = _selectedColorIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColorIndex = index;
                              });
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors[index],
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: -4,
                                    right: 4,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0019FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check,
                                          size: 12, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 54,
            left: 24,
            child: SizedBox(
              width: 20,
              height: 20,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return ElevatedButton.icon(
                onPressed: () {
                  final selectedProduct = Product(
                    id: product.id,
                    title: product.title,
                    price: product.price,
                    description: product.description,
                    images: product.images,
                    selectedSize: sizes[_selectedSizeIndex],
                    selectedColorName:
                    _getColorName(colors[_selectedColorIndex]),
                  );
                  context.read<CartBloc>().add(AddToCart(selectedProduct));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} added to cart!')),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add to cart",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0019FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
