import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:my_app/appservice/product.dart';

@injectable
class FavoritesStorageService {
  static const String _boxName = 'favoritesBox';
  late final Box _box;

  FavoritesStorageService() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
    }
  }

  Future<void> saveFavorites(Set<Product> favorites) async {
    await _box.clear();
    for (var product in favorites) {
      await _box.put(product.id, product);
    }
  }

  Set<Product> loadFavorites() {
    final Set<Product> favorites = {};
    for (var key in _box.keys) {
      final product = _box.get(key);
      if (product is Product) {
        favorites.add(product);
      }
    }
    return favorites;
  }

  Future<void> clearFavorites() async {
    await _box.clear();
  }
}
