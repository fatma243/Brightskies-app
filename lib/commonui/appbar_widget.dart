import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/appservice/cart_bloc.dart';
import 'package:my_app/appservice/cart_state.dart';
import 'package:my_app/cart/presentation/screens/cart_page.dart';
import 'package:my_app/search/presentation/screens/search_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;

  const CustomAppBar({super.key, this.showSearch = true});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
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
                if (showSearch)
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchPage()),
                      );
                    },
                  )
                else
                  const SizedBox(width: 20, height: 20),

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
    );
  }
}
