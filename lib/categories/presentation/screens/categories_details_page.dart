import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/productdetails/presentation/screens/product_detail_screen.dart';
import 'package:my_app/search/presentation/screens/search_page.dart';
import '../../../appservice/cart_bloc.dart';
import '../../../appservice/cart_event.dart';
import '../../../appservice/cart_state.dart';
import '../../../appservice/categories_bloc.dart';
import '../../../appservice/categories_event.dart';
import '../../../appservice/categories_state.dart';
import '../../../appservice/favorites_bloc.dart';
import '../../../appservice/favorites_event.dart';
import '../../../appservice/favorites_state.dart';
import '../../../appservice/filter_bloc.dart';
import '../../../appservice/filter_event.dart';
import '../../../appservice/filter_page.dart';
import '../../../appservice/product.dart';
import '../../../cart/presentation/screens/cart_page.dart';
import '../../../commonui/sort_filter_row.dart';
import '../../../appservice/sort_option.dart';
import '../../../favorites.dart';

class CategoryDetailsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryDetailsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  StreamSubscription? _filterSubscription;

  @override
  void initState() {
    super.initState();
    final filter = context.read<FilterBloc>().state.filter;
    final currentSort = context.read<CategoryDetailsBloc>().currentSort;

    context.read<CategoryDetailsBloc>().add(
      FetchCategoryProducts(widget.categoryId, filter: filter, sortOption: currentSort),
    );

    _filterSubscription = context.read<FilterBloc>().stream.listen((filterState) {
      final filter = filterState.filter;
      final currentSort = context.read<CategoryDetailsBloc>().currentSort;

      context.read<CategoryDetailsBloc>().add(
        FetchCategoryProducts(widget.categoryId, filter: filter, sortOption: currentSort),
      );
    });
  }


  @override
  void dispose() {
    _filterSubscription?.cancel();
    context.read<FilterBloc>().add(ClearFilter());
    super.dispose();
  }

  void _showSortOptions() async {
    final selected = await showModalBottomSheet<SortOption>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price: Low to High'),
              onTap: () => Navigator.pop(context, SortOption.priceLowToHigh),
            ),
            ListTile(
              title: const Text('Name: A to Z'),
              onTap: () => Navigator.pop(context, SortOption.nameAZ),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      context.read<CategoryDetailsBloc>().add(SortCategoryProducts(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<CategoryDetailsBloc, CategoryDetailsState>(
        builder: (context, state) {
          if (state is CategoryDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryDetailsError) {
            return Center(child: Text(state.message));
          } else if (state is CategoryDetailsLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return Column(
              children: [
                SortFilterRow(
                  onSortPressed: _showSortOptions,
                  onFilterPressed: () async {
                    final selectedFilter = await showModalBottomSheet<ProductFilter>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => FilterPage(categoryId: widget.categoryId),
                    );

                    if (selectedFilter != null) {

                      context.read<FilterBloc>().add(
                        ApplyFilters(
                          categoryId: widget.categoryId,
                          categorySlug: widget.categoryName,
                          minPrice: selectedFilter.minPrice,
                          maxPrice: selectedFilter.maxPrice,
                        ),
                      );

                      final currentSort = context.read<CategoryDetailsBloc>().currentSort;

                      context.read<CategoryDetailsBloc>().add(
                        FetchCategoryProducts(
                          widget.categoryId,
                          filter: selectedFilter,
                          sortOption: currentSort,
                        ),
                      );
                    }
                  },


                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return _buildProductCard(product);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF0019FF)),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchPage(
                categoryId: widget.categoryId,
                categoryName: widget.categoryName,
              ),
            ),
          );
        },
        child: SizedBox(
          width: 225,
          height: 44,
          child: AbsorbPointer(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.categoryName,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: Icon(Icons.search, color: Color(0xFF2F3036)),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: const Color(0xFFF8F9FE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.black, size: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
          },
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final totalCount = state.items.values.fold<int>(0, (sum, qty) => sum + qty);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                ),
                if (totalCount > 0)
                  Positioned(
                    bottom: 2,
                    right: 2,
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
        )
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Image.network(
                      product.images.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 8,
                  child: BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      final isFavorite = state.items[product] ?? false;

                      return GestureDetector(
                        onTap: () {
                          final bloc = context.read<FavoritesBloc>();
                          if (isFavorite) {
                            bloc.add(RemoveFromFavorites(product));
                          } else {
                            bloc.add(AddToFavorites(product));
                          }
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFF0019FF),
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 165.5,
              height: 121,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF1F2024),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "€ ${product.price}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () => context.read<CartBloc>().add(AddToCart(product)),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Color(0xFF0019FF)),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0019FF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
