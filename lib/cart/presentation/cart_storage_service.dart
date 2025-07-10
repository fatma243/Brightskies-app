import 'dart:convert';
import 'package:my_app/appservice/product.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartStorageService {
  final SharedPreferences prefs;
  static const _key = 'user_cart';

  CartStorageService(this.prefs);

  Future<void> saveCart(Map<Product, int> cart) async {
    final List<Map<String, dynamic>> encoded = cart.entries.map((entry) {
      return {
        'product': entry.key.toJson(),
        'quantity': entry.value,
      };
    }).toList();

    await prefs.setString(_key, jsonEncode(encoded));
  }

  Map<Product, int> loadCart() {
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return {};

    final List decoded = jsonDecode(jsonString);
    final Map<Product, int> cart = {};
    for (final item in decoded) {
      final product = Product.fromJson(item['product']);
      final quantity = item['quantity'] as int;
      cart[product] = quantity;
    }
    return cart;
  }
}