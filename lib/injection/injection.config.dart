// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:my_app/appservice/cart_bloc.dart' as _i126;
import 'package:my_app/cart/presentation/cart_storage_service.dart' as _i128;
import 'package:my_app/injection/injection.dart' as _i237;
import 'package:my_app/network/api_client.dart' as _i737;
import 'package:my_app/network/network_module.dart' as _i98;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final blocModule = _$BlocModule();
    gh.factory<_i128.CartStorageService>(() => _i128.CartStorageService());
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.factory<_i126.CartBloc>(
        () => _i126.CartBloc(gh<_i128.CartStorageService>()));
    gh.lazySingleton<_i737.ApiClient>(
        () => networkModule.getApiClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i126.ProductBloc>(
        () => blocModule.provideProductBloc(gh<_i737.ApiClient>()));
    return this;
  }
}

class _$NetworkModule extends _i98.NetworkModule {}

class _$BlocModule extends _i237.BlocModule {}
