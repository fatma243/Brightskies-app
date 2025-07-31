import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../appservice/cart_bloc.dart';
import '../../../appservice/cart_event.dart';
import '../../../appservice/filter_page.dart';
import '../../../appservice/product.dart';
import '../../../appservice/search_event.dart';
import '../../../appservice/search_state.dart';
import '../../../commonui/sort_filter_row.dart';
import '../../../productdetails/presentation/screens/product_detail_screen.dart';

import '../../../network/api_client.dart';
import '../../../appservice/search_bloc.dart';
import '../search_service.dart';
import 'package:my_app/appservice/sort_option.dart';
class SearchPage extends StatefulWidget {
  final String? categoryName;
  final int? categoryId;
  final bool goToHomeOnBack;

  const SearchPage({
    super.key,
    this.categoryName,
    this.categoryId,
    this.goToHomeOnBack = false,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late SearchBloc searchBloc;
  late SearchService searchService;
  late Box<List> recentSearchesBox;

  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    recentSearchesBox = Hive.box<List>('recentSearchesBox');

    final apiClient = GetIt.instance<ApiClient>();
    searchService = SearchService(
      recentSearchesBox: recentSearchesBox,
      apiClient: apiClient,
    );

    searchService.loadRecentSearches();

    searchBloc = SearchBloc(apiClient)
      ..add(LoadCategoryProducts(categoryId: widget.categoryId));
  }

  // void _handleBack() {
  //   if (widget.goToHomeOnBack) {
  //     Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }
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
      searchBloc.add(SortProducts(selected));
    }

  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: searchBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0019FF)),
            onPressed: () {
              Navigator.pop(context);
            },

          ),
          title: SizedBox(
            width: 225,
            height: 44,
            child: _buildSearchField(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (!hasSearched) {
                final recent = searchService.recentSearches;
                if (recent.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "RECENT SEARCHES",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        letterSpacing: 0.5,
                        color: Color(0xFF71727A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...recent.map((term) => ListTile(
                      title: Text(term, style: const TextStyle(fontSize: 14)),
                      trailing: IconButton(
                        icon: Container(
                          width: 12,
                          height:12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8F9098),
                            shape:BoxShape.circle,
                          ),
                            child: const Icon(
                              Icons.close,
                              color:Colors.white,
                              size:10,
                            )

                        ),
                        onPressed: () {
                          setState(() {
                            searchService.recentSearches.remove(term);
                            searchService.saveRecentSearches();
                          });
                        },
                      ),
                      onTap: () {
                        searchController.text = term;
                        setState(() {
                          hasSearched = true;
                        });
                        searchService.addRecentSearch(term);
                        searchBloc.add(PerformSearch(term));
                      },
                    )),
                  ],
                );
              }

              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchLoaded) {
                if (state.results.isEmpty) {
                  return const Center(child: Text("No items found"));
                }
                return Column(
                  children: [
                    SortFilterRow(
                      onSortPressed: _showSortOptions,
                      onFilterPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FilterPage()),
                        );
                      },
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: state.results.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (_, index) => _buildProductCard(state.results[index]),
                      ),
                    ),
                  ],
                );
              } else if (state is SearchError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      onTap: () {
        setState(() {
          hasSearched = false;
        });
      },
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          setState(() {
            hasSearched = true;
          });
          searchService.addRecentSearch(value);
          searchBloc.add(PerformSearch(value));
        }
      },
      decoration: InputDecoration(
        hintText: widget.categoryName ?? 'Search products...',
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
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(product.images.first, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                const Positioned(
                  top: 12,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Color(0xFF0019FF), size: 20),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("€ ${product.price}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () => context.read<CartBloc>().add(AddToCart(product)),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xFF0019FF)),
                        ),
                        child: const Text('Add to cart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0019FF))),
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
