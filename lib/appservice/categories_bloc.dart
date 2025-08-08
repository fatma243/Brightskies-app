import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/appservice/sort_option.dart';
import '../network/api_client.dart';
import 'categories_event.dart';
import 'categories_state.dart';
import 'package:my_app/appservice/product.dart';

class CategoryDetailsBloc extends Bloc<CategoryDetailsEvent, CategoryDetailsState> {
  final ApiClient apiClient;

  List<Product> _allProducts = [];
  ProductFilter? _currentFilter;
  SortOption? _currentSort;
  int? _currentCategoryId;

  CategoryDetailsBloc(this.apiClient) : super(CategoryDetailsInitial()) {
    on<FetchCategoryProducts>(_onFetchProducts);
    on<SortCategoryProducts>(_onSortProducts);
  }

  Future<void> _onFetchProducts(FetchCategoryProducts event, Emitter<CategoryDetailsState> emit) async {
    emit(CategoryDetailsLoading());


    _currentCategoryId = event.categoryId;
    _currentFilter = event.filter ?? _currentFilter;
    _currentSort = event.sortOption ?? _currentSort;

    try {
      _allProducts = await apiClient.getProductsByCategory(event.categoryId);

      List<Product> filtered = _applyFilter(_allProducts, _currentFilter);

      if (_currentSort != null) {
        filtered = sortProducts(filtered, _currentSort!);
      }

      emit(CategoryDetailsLoaded(filtered));
    } catch (e) {
      emit(CategoryDetailsError("Failed to load products"));
    }
  }

  void _onSortProducts(SortCategoryProducts event, Emitter<CategoryDetailsState> emit) {
    _currentSort = event.option;

    List<Product> filtered = _applyFilter(_allProducts, _currentFilter);
    filtered = sortProducts(filtered, _currentSort!);

    emit(CategoryDetailsLoaded(filtered));
  }

  List<Product> _applyFilter(List<Product> products, ProductFilter? filter) {
    if (filter == null) {
      return products;
    }
    final min = filter.minPrice ?? 0;
    final max = filter.maxPrice ?? double.infinity;

    return products.where((product) {
      return product.price >= min && product.price <= max;
    }).toList();
  }

  SortOption? get currentSort => _currentSort;
  ProductFilter? get currentFilter => _currentFilter;
}
