import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'api_client.dart';


@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  ApiClient getApiClient(Dio dio) => ApiClient(dio);
}
