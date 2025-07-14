import 'package:hive/hive.dart';
import 'package:my_app/appservice/product.dart';

class CartStorageService {
  static const String _boxName = 'cartBox';
  late final Box _box;

  CartStorageService() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
    }
  }

  Future<void> saveCart(Map<Product, int> cart) async {
    await _box.clear();
    for (var entry in cart.entries) {
      await _box.put(entry.key.id, {
        'product': entry.key,
        'quantity': entry.value,
      });
    }
  }

  Map<Product, int> loadCart() {
    final Map<Product, int> cart = {};
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data is Map &&
          data['product'] is Product &&
          data['quantity'] is int) {
        cart[data['product'] as Product] = data['quantity'] as int;
      }
    }
    return cart;
  }

  Future<void> clearCart() async {
    await _box.clear();
  }
}
