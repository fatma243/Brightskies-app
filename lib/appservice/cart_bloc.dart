import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../cart/presentation/cart_storage_service.dart';
import '../network/api_client.dart';
import 'product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@injectable
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
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiClient apiClient;

  ProductBloc(this.apiClient) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await apiClient.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}