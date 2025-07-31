import 'package:hive/hive.dart';
import '../../appservice/product.dart';
import '../../appservice/sort_option.dart';
import '../../network/api_client.dart';


class SearchService {
  final Box<List> recentSearchesBox;
  final ApiClient apiClient;

  List<String> recentSearches = [];
  List<Product> allCategoryProducts = [];
  List<Product> results = [];

  SearchService({
    required this.recentSearchesBox,
    required this.apiClient,
  });


  void loadRecentSearches() {
    final storedSearches = recentSearchesBox.get('searches') ?? [];
    recentSearches = List<String>.from(storedSearches);
  }


  void saveRecentSearches() {
    recentSearchesBox.put('searches', recentSearches);
  }


  void addRecentSearch(String query) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);


      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }

      saveRecentSearches();
    }
  }


  void removeRecentSearch(String query) {
    recentSearches.remove(query);
    saveRecentSearches();
  }


  Future<List<Product>> loadCategoryProducts(int? categoryId) async {
    final allProducts = await apiClient.getAllProducts();


    if (categoryId != null) {
      allCategoryProducts = allProducts.where((product) => product.categoryId == categoryId).toList();
    } else {
      allCategoryProducts = allProducts;
    }


    results = List<Product>.from(allCategoryProducts);
    return results;
  }


  Future<List<Product>> search(String input) async {
    final query = input.toLowerCase().trim();

    results = allCategoryProducts.where((product) {
      return product.title.toLowerCase().startsWith(query);
    }).toList();

    addRecentSearch(input);

    return results;
  }

}
