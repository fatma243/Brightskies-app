import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/appservice/search_event.dart';
import 'package:my_app/appservice/search_state.dart';
import '../../../appservice/product.dart';
import '../../../network/api_client.dart';
import '../search/presentation/screens/search_page.dart'; // ✅ import your SortOption enum
import 'package:my_app/appservice/sort_option.dart';
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
                (p) => p.title.toLowerCase().contains(event.query.toLowerCase())
        ).toList();
        emit(SearchLoaded(filtered));
      } catch (e) {
        emit(SearchError("Search failed"));
      }
    });

    on<SortProducts>((event, emit) {
      if (state is SearchLoaded) {
        final results = [...(state as SearchLoaded).results];

        results.sort((a, b) {
          switch (event.option) {
            case SortOption.priceLowToHigh:
              return a.price.compareTo(b.price);
            case SortOption.nameAZ:
              return a.title.toLowerCase().compareTo(b.title.toLowerCase());
          }
        });

        emit(SearchLoaded(results));
      }
    });
  }
}
