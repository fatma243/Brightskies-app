import 'package:equatable/equatable.dart';
import '../../appservice/product.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState extends Equatable {
  final Map<Product, bool> items;
  final FavoritesStatus status;
  final String? error;

  const FavoritesState({
    this.items = const {},
    this.status = FavoritesStatus.initial,
    this.error,
  });

  FavoritesState copyWith({
    Map<Product, bool>? items,
    FavoritesStatus? status,
    String? error,
  }) {
    return FavoritesState(
      items: items ?? this.items,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, status, error];
}
