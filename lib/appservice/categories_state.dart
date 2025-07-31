import 'package:my_app/appservice/product.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}
abstract class CategoryDetailsState {}

class CategoryDetailsInitial extends CategoryDetailsState {}

class CategoryDetailsLoading extends CategoryDetailsState {}

class CategoryDetailsLoaded extends CategoryDetailsState {
  final List<Product> products;

  CategoryDetailsLoaded(this.products);
}

class CategoryDetailsError extends CategoryDetailsState {
  final String message;

  CategoryDetailsError(this.message);
}

