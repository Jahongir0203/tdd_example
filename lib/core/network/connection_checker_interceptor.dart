import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@Singleton()
class ConnectionCheckerInterceptor extends Interceptor {
  final InternetConnection _checker;

  const ConnectionCheckerInterceptor(this._checker);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasInternet = await _checker.hasInternetAccess;

    if (!hasInternet) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NoInternetException(),
          message: 'Internet ulanishi yo\'q',
        ),
        true,
      );
      return;
    }

    handler.next(options);
  }
}

class NoInternetException implements Exception {
  const NoInternetException();

  @override
  String toString() => 'NoInternetException: Internet ulanishi yo\'q';
}
