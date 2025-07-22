import 'package:flutter/material.dart';
import '../../../appservice/cart_state.dart';
import '../../../cart/presentation/screens/cart_page.dart';
import '../../../appservice/cart_bloc.dart';
import '../../../appservice/product.dart';
import '../../../profile.dart';
import 'product_card.dart';
import 'package:my_app/commonui/title_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 72,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: Icon(Icons.search, color: Colors.black, size: 20),
                  ),
                  SizedBox(
                    width: 70.23,
                    height: 35.46,
                    child: SvgPicture.asset('assets/images/Logo.svg', fit: BoxFit.contain),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.favorite_border, color: Colors.black, size: 24),
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final totalCount = state.items.values.fold<int>(0, (sum, quantity) => sum + quantity);

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                                iconSize: 24,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const CartPage()),
                                  );
                                },
                              ),
                              if (totalCount > 0)
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0019FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$totalCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),


      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeaturedSection(),
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

  final String candleImage = 'assets/images/candles.jpg';

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.5,
        child: Image.asset(
          candleImage,
          height: 428,
          width: 375,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: SectionTitle(text: "All Products"),
              ),
              SizedBox(
                height: 189,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ProductCard(product: state.products[index]);
                  },
                ),
              ),
            ],
          );
        } else if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
