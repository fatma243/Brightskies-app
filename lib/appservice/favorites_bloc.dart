import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../appservice/product.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearFavorites>(_onClearFavorites);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      emit(state.copyWith(
        items: event.loadedItems,
        status: FavoritesStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onAddToFavorites(AddToFavorites event, Emitter<FavoritesState> emit) {
    final updatedItems = Map<Product, bool>.from(state.items);
    updatedItems[event.product] = true;
    emit(state.copyWith(items: updatedItems, status: FavoritesStatus.loaded));
  }

  void _onRemoveFromFavorites(RemoveFromFavorites event, Emitter<FavoritesState> emit) {
    final updatedItems = Map<Product, bool>.from(state.items);
    updatedItems.remove(event.product);
    emit(state.copyWith(items: updatedItems, status: FavoritesStatus.loaded));
  }

  void _onClearFavorites(ClearFavorites event, Emitter<FavoritesState> emit) {
    emit(state.copyWith(items: {}, status: FavoritesStatus.loaded));
  }
}
