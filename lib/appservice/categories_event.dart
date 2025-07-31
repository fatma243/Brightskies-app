import 'package:my_app/appservice/sort_option.dart';

abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

abstract class CategoryDetailsEvent {}

class FetchCategoryProducts extends CategoryDetailsEvent {
  final int categoryId;

  FetchCategoryProducts(this.categoryId);
}

class SortCategoryProducts extends CategoryDetailsEvent {
  final SortOption option;
  SortCategoryProducts(this.option);
  List<Object?> get props => [option];
}
