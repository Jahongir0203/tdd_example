import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'connection_checker_interceptor.dart';

@Singleton()
class MyLogInterceptor extends Interceptor {
  static const _sensitive = ['password', 'token', 'secret', 'authorization'];

  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    log('▶ ${o.method} ${o.uri} | body:${_mask(o.data)}');
    super.onRequest(o, h);
  }

  @override
  void onResponse(Response r, ResponseInterceptorHandler h) {
    log('✓ ${r.statusCode} ${r.requestOptions.uri} | body:${r.data}');
    super.onResponse(r, h);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler h) {
    final isNoInternet = e.error is NoInternetException;
    final label = isNoInternet ? '📵 NO_INTERNET' : '✗ ${e.type.name}';
    log(
      '$label ${e.requestOptions.uri} | status:${e.response?.statusCode} | ${e.message}',
    );
    super.onError(e, h);
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
