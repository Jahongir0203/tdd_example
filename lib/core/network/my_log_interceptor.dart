import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'connection_checker_interceptor.dart';

@Singleton()
class MyLogInterceptor extends Interceptor {
  static const _sensitive = ['password', 'token', 'secret', 'authorization'];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('▶ ${options.method} ${options.uri} | body:${_mask(options.data)}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '✓ ${response.statusCode} ${response.requestOptions.uri} | body:${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isNoInternet = err.error is NoInternetException;
    final label = isNoInternet ? '📵 NO_INTERNET' : '✗ ${err.type.name}';
    log(
      '$label ${err.requestOptions.uri} | status:${err.response?.statusCode} | ${err.message}',
    );
    super.onError(err, handler);
  }

  dynamic _mask(dynamic data) {
    if (data is! Map) return data;
    return Map.from(data)..updateAll(
      (k, v) => _sensitive.any((s) => k.toString().toLowerCase().contains(s))
          ? '••••'
          : v,
    );
  }
}
