import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/appservice/search_event.dart';
import 'package:my_app/appservice/search_state.dart';
import '../../../appservice/product.dart';
import '../../../network/api_client.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiClient apiClient;
  List<Product> _categoryProducts = [];

  SearchBloc(this.apiClient) : super(SearchInitial()) {
    on<LoadCategoryProducts>((event, emit) async {
      emit(SearchLoading());
      try {
        final all = await apiClient.getAllProducts();
        if (event.categoryId != null) {
          _categoryProducts = all.where((p) => p.categoryId == event.categoryId).toList();
        } else {
          _categoryProducts = all;
        }
        emit(SearchLoaded(_categoryProducts));
      } catch (e) {
        emit(SearchError("Failed to load products"));
      }
    });

    on<PerformSearch>((event, emit) async {
      emit(SearchLoading());
      try {
        final filtered = _categoryProducts.where(
              (p) => p.title.toLowerCase().contains(event.query.toLowerCase()),
        ).toList();
        emit(SearchLoaded(filtered));
      } catch (e) {
        emit(SearchError("Search failed"));
      }
    });

    on<ApplyFilters>((event, emit) async {
      emit(SearchLoading());
      try {
        List<Product> filtered = [..._categoryProducts];

        if (event.categoryId != null) {
          filtered = filtered.where((p) => p.categoryId == event.categoryId).toList();
        }

        if (event.priceRange != null) {
          final minPrice = event.priceRange!.start;
          final maxPrice = event.priceRange!.end;
          filtered = filtered.where((p) =>
          p.price >= minPrice && p.price <= maxPrice).toList();
        }

        emit(SearchLoaded(filtered));
      } catch (e) {
        emit(SearchError("Filter application failed"));
      }
    });
  }
}
