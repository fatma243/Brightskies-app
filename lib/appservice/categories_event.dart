import 'package:my_app/appservice/product.dart';
import 'package:my_app/appservice/sort_option.dart';

abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

abstract class CategoryDetailsEvent {}

class FetchCategoryProducts extends CategoryDetailsEvent {
  final int categoryId;
  final ProductFilter? filter;
  final SortOption? sortOption;
  FetchCategoryProducts(this.categoryId, {this.filter,this.sortOption});
}

class SortCategoryProducts extends CategoryDetailsEvent {
  final SortOption option;
  SortCategoryProducts(this.option);
  List<Object?> get props => [option];
}
