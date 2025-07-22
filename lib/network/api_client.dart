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
}
