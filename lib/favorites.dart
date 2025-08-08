import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appservice/favorites_bloc.dart';
import '../../../appservice/favorites_event.dart';
import '../../../appservice/favorites_state.dart';


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final favoriteItems = state.items.keys.toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(10),
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF0019FF)),
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            "My Favorites",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                if (favoriteItems.isEmpty)
                  const Expanded(
                    child: Center(child: Text("No favorites yet.")),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: favoriteItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final product = favoriteItems[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: product.images.isNotEmpty
                                      ? Image.network(
                                    product.images[0],
                                    width: 90,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                                  )
                                      : Container(
                                    width: 90,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 30),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.title,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${product.selectedColorName ?? 'Color'} / ${product.selectedSize ?? 'Size'}",
                                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "€ ${product.price.toStringAsFixed(2)}",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.favorite, color: Color(0xFF0019FF)),
                                onPressed: () {
                                  context.read<FavoritesBloc>().add(RemoveFromFavorites(product));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
