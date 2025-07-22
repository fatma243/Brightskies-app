import 'product.dart';
class CartState {
  final Map<Product, int> items;

  const CartState(this.items);

  int get count => items.values.fold(0, (sum, qty) => sum + qty);

  int getQuantity(Product product) => items[product] ?? 0;

  bool contains(Product product) => items.containsKey(product);

  double get totalPrice =>
      items.entries.fold(0, (sum, e) => sum + (e.key.price * e.value));

  CartState copyWith(Map<Product, int> updatedItems) {
    return CartState({...updatedItems});
  }
}


abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
