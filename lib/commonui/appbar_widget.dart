import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/appservice/cart_bloc.dart';
import 'package:my_app/appservice/cart_state.dart';
import 'package:my_app/cart/presentation/screens/cart_page.dart';
import 'package:my_app/search/presentation/screens/search_page.dart';

import '../favorites.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;

  const CustomAppBar({super.key, this.showSearch = true});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showSearch)
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 24),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              )
            else
              const SizedBox(width: 24),

            SizedBox(
              height: 40,
              child: SvgPicture.asset('assets/images/Logo.svg', fit: BoxFit.contain),
            ),

            Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesPage()),
                    );
                  },
                ),
                const SizedBox(width: 8),


                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final totalCount = state.items.values.fold<int>(0, (sum, qty) => sum + qty);

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 24),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CartPage()),
                            );
                          },
                        ),
                        if (totalCount > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0019FF),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
    );
  }
}
