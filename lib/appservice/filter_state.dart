import 'package:my_app/appservice/product.dart';

class FilterState {
  final int? categoryId;
  final ProductFilter filter;

  FilterState({
    required this.filter,
    this.categoryId,
  });

  FilterState copyWith({
    int? categoryId,
    ProductFilter? filter,
  }) {
    return FilterState(
      categoryId: categoryId ?? this.categoryId,
      filter: filter ?? this.filter,
    );
  }
}
