import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../product.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}

class IncrementQuantity extends CartEvent {
  final Product product;
  IncrementQuantity(this.product);
}

class DecrementQuantity extends CartEvent {
  final Product product;
  DecrementQuantity(this.product);
}

class CartState {
  final Map<Product, int> items;

  const CartState(this.items);
  int get count => items.values.fold(0, (sum, qty) => sum + qty);

  int getQuantity(Product product) => items[product] ?? 0;

  bool contains(Product product) => items.containsKey(product);

  double get totalPrice => items.entries
      .fold(0, (sum, e) => sum + (e.key.price * e.value));

  CartState copyWith(Map<Product, int> updatedItems) {
    return CartState({...updatedItems});
  }
}
class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart(this.product);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState({})) {
    on<AddToCart>((event, emit) {
      final updatedItems = Map<Product, int>.from(state.items);
      updatedItems[event.product] = (updatedItems[event.product] ?? 0) + 1;
      emit(CartState(updatedItems));
    });

    on<IncrementQuantity>((event, emit) {
      final updatedItems = Map<Product, int>.from(state.items);
      if (updatedItems.containsKey(event.product)) {
        updatedItems[event.product] = updatedItems[event.product]! + 1;
        emit(CartState(updatedItems));
      }
    });

    on<DecrementQuantity>((event, emit) {
      final updatedItems = Map<Product, int>.from(state.items);
      if (updatedItems.containsKey(event.product)) {
        final currentQty = updatedItems[event.product]!;
        if (currentQty <= 1) {
          updatedItems.remove(event.product);
        } else {
          updatedItems[event.product] = currentQty - 1;
        }
        emit(CartState(updatedItems));
      }
    });
    on<RemoveFromCart>((event, emit) {
      final updatedItems = Map<Product, int>.from(state.items);
      updatedItems.remove(event.product);
      emit(CartState(updatedItems));
    });

  }
}


