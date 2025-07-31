import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../appservice/cart_bloc.dart';
import '../appservice/categories_bloc.dart';
import '../network/api_client.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();

@module
abstract class BlocModule {
  @lazySingleton
  ProductBloc provideProductBloc(ApiClient apiClient) => ProductBloc(apiClient);

  @factoryMethod
  CategoryDetailsBloc provideCategoryDetailsBloc(ApiClient apiClient) =>
      CategoryDetailsBloc(apiClient);
}


