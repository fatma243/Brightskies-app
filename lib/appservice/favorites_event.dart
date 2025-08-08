import 'package:equatable/equatable.dart';
import '../../appservice/product.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  final Map<Product, bool> loadedItems;

  const LoadFavorites(this.loadedItems);

  @override
  List<Object?> get props => [loadedItems];
}

class AddToFavorites extends FavoritesEvent {
  final Product product;

  const AddToFavorites(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromFavorites extends FavoritesEvent {
  final Product product;

  const RemoveFromFavorites(this.product);

  @override
  List<Object?> get props => [product];
}

class ClearFavorites extends FavoritesEvent {
  const ClearFavorites();
}
