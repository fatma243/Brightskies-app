import '../appservice/product.dart';

enum SortOption {
  priceLowToHigh,
  nameAZ,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.nameAZ:
        return 'Name: A to Z';

    }
  }
}

List<Product> sortProducts(List<Product> products, SortOption option) {
  final sorted = [...products];

  sorted.sort((a, b) {
    switch (option) {
      case SortOption.priceLowToHigh:
        return a.price.compareTo(b.price);
      case SortOption.nameAZ:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }
  });

  return sorted;
}
