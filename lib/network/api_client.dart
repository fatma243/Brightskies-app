import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../appservice/product.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.escuelajs.co/api/v1/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("products")
  Future<List<Product>> getProducts();

  @GET("products/{id}")
  Future<Product> getProductDetails(@Path("id") int id);

  @GET("categories")
  Future<List<Category>> getCategories();

  @GET("categories/{id}/products")
  Future<List<Product>> getProductsByCategory(@Path("id") int categoryId);

  @GET("products/")
  Future<List<Product>> searchProducts(@Query("title") String title);

  @GET("products/")
  Future<List<Product>> getAllProducts();

  @GET("products")
  Future<List<Product>>getFilteredProducts ({
    @Query("title") String? title,
    @Query("price_min") int? priceMin,
    @Query("price_max") int? priceMax,
    @Query("categoryId") int? categoryId,
    @Query("categorySlug") int? categorySlug,
  });

}
