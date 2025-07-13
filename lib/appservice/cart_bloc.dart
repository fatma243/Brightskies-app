import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart/presentation/cart_storage_service.dart';
import 'product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartStorageService storageService;

  CartBloc(this.storageService) : super(const CartState({})) {
    on<LoadCart>((event, emit) {
      emit(CartState(event.loadedItems));
    });

    on<AddToCart>((event, emit) {
      final updated = Map<Product, int>.from(state.items);
      updated[event.product] = (updated[event.product] ?? 0) + 1;
      emit(CartState(updated));
      storageService.saveCart(updated);
    });

    on<IncrementQuantity>((event, emit) {
      final updated = Map<Product, int>.from(state.items);
      if (updated.containsKey(event.product)) {
        updated[event.product] = updated[event.product]! + 1;
        emit(CartState(updated));
        storageService.saveCart(updated);
      }
    });

    on<DecrementQuantity>((event, emit) {
      final updated = Map<Product, int>.from(state.items);
      if (updated.containsKey(event.product)) {
        final qty = updated[event.product]!;
        if (qty <= 1) {
          updated.remove(event.product);
        } else {
          updated[event.product] = qty - 1;
        }
        emit(CartState(updated));
        storageService.saveCart(updated);
      }
    });

    on<RemoveFromCart>((event, emit) {
      final updated = Map<Product, int>.from(state.items);
      updated.remove(event.product);
      emit(CartState(updated));
      storageService.saveCart(updated);
    });
    on<ClearCart>((event, emit) async {
      await storageService.clearCart();
      emit(const CartState({}));
    });


  }
}