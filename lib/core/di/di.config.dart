// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alice/alice.dart' as _i917;
import 'package:alice_dio/alice_dio_adapter.dart' as _i433;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i695;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../features/comments/data/datasource/comments_datasource.dart'
    as _i955;
import '../../features/comments/data/repository/comments_repository_impl.dart'
    as _i898;
import '../../features/comments/domain/repository/comments_repository.dart'
    as _i1070;
import '../../features/comments/presentation/cubits/comments_cubit/comments_cubit.dart'
    as _i898;
import '../network/connection_checker_interceptor.dart' as _i676;
import '../network/dio_client.dart' as _i667;
import '../network/my_log_interceptor.dart' as _i406;
import 'di_module.dart' as _i211;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final diModule = _$DiModule();
    gh.singleton<_i161.InternetConnection>(() => diModule.connectionChecker);
    await gh.singletonAsync<_i695.CacheOptions>(
      () => diModule.cacheOptions,
      preResolve: true,
    );
    gh.singleton<_i433.AliceDioAdapter>(() => diModule.aliceDioAdapter);
    gh.singleton<_i917.Alice>(() => diModule.alice);
    gh.singleton<_i406.MyLogInterceptor>(() => _i406.MyLogInterceptor());
    gh.singleton<_i676.ConnectionCheckerInterceptor>(
      () => _i676.ConnectionCheckerInterceptor(gh<_i161.InternetConnection>()),
    );
    gh.singleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i917.Alice>(),
        gh<_i433.AliceDioAdapter>(),
        gh<_i695.CacheOptions>(),
        gh<_i406.MyLogInterceptor>(),
        gh<_i676.ConnectionCheckerInterceptor>(),
      )..init(),
    );
    gh.lazySingleton<_i955.CommentsDatasource>(
      () => _i955.CommentsDatasourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i1070.CommentsRepository>(
      () => _i898.CommentsRepositoryImpl(gh<_i955.CommentsDatasource>()),
    );
    gh.factory<_i898.CommentsCubit>(
      () => _i898.CommentsCubit(gh<_i1070.CommentsRepository>()),
    );
    return this;
  }
}

class _$DiModule extends _i211.DiModule {}
