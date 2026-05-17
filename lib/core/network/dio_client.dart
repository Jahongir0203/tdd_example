import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:tdd_example/core/constants/app_const.dart';
import 'package:tdd_example/core/network/connection_checker_interceptor.dart';
import 'package:tdd_example/core/network/my_log_interceptor.dart';

@Singleton()
class DioClient {
  final Alice _alice;
  final AliceDioAdapter _aliceAdapter;
  final CacheOptions _cacheOptions;
  final MyLogInterceptor _myLogInterceptor;
  final ConnectionCheckerInterceptor _connectionCheckerInterceptor;

  DioClient(
    this._alice,
    this._aliceAdapter,
    this._cacheOptions,
    this._myLogInterceptor,
    this._connectionCheckerInterceptor,
  );

  @PostConstruct()
  void init() => _alice.addAdapter(_aliceAdapter);

  Dio client({Duration? cacheDuration, String? baseUrl}) {
    final devMode = AppConst.devMode;
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConst.baseUrl,
        receiveTimeout: AppConst.timeOut,
        connectTimeout: AppConst.timeOut,
        sendTimeout: AppConst.timeOut,
      ),
    );

    final interceptors = <Interceptor>[
      if (devMode) _aliceAdapter,
      if (devMode) _myLogInterceptor,
      if (cacheDuration == null || cacheDuration.inSeconds == 0)
        _connectionCheckerInterceptor,
      if (cacheDuration != null)
        DioCacheInterceptor(
          options: _cacheOptions.copyWith(
            policy: cacheDuration.inSeconds == 0
                ? CachePolicy.refreshForceCache
                : CachePolicy.forceCache,
            maxStale: cacheDuration,
          ),
        ),
    ];
    dio.interceptors.addAll(interceptors);

    return dio;
  }
}
