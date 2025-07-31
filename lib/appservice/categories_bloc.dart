import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/appservice/sort_option.dart';
import '../network/api_client.dart';
import 'categories_event.dart';
import 'categories_state.dart';
import 'package:my_app/appservice/product.dart';


class CategoryDetailsBloc extends Bloc<CategoryDetailsEvent, CategoryDetailsState> {
  final ApiClient apiClient;
  List<Product> _products = [];

  CategoryDetailsBloc(this.apiClient) : super(CategoryDetailsInitial()) {
    // Fetch products
    on<FetchCategoryProducts>((event, emit) async {
      emit(CategoryDetailsLoading());
      try {
        _products = await apiClient.getProductsByCategory(event.categoryId);
        emit(CategoryDetailsLoaded(_products));
      } catch (e) {
        emit(CategoryDetailsError("Failed to load products"));
      }
    });

    on<SortCategoryProducts>((event, emit) {
      _products = sortProducts(_products, event.option); // ✅ use shared helper
      emit(CategoryDetailsLoaded(_products));
    });
  }
}
