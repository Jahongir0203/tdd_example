import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdd_example/core/router/routes.dart';

import 'app_toast.dart';

class ErrorHelper {
  const ErrorHelper._();

  static const _localizedKeys = {'en', 'ru', 'uz', 'uz_cyr', 'qq'};

  static bool _isLocalizedMap(Map map) =>
      map.keys.any((k) => _localizedKeys.contains(k));

  static Locale? get _currentLocale {
    final context = router.navigatorKey.currentContext;
    if (context == null) return null;
    return Localizations.localeOf(context);
  }

  static String _extractLocalized(Map<String, dynamic> map) {
    final locale = _currentLocale;
    if (locale == null) return map['uz'] ?? map['en'] ?? map.values.first ?? '';

    final lang = locale.languageCode;
    final script = locale.scriptCode;

    if (script == 'Cyrl' && map['uz_cyr'] != null) {
      return map['uz_cyr'] as String;
    }

    if (lang == 'kaa') {
      return (map['qq'] ?? map['ru'] ?? map['en'] ?? '') as String;
    }

    return (map[lang] ?? map['uz'] ?? map['en'] ?? map.values.firstOrNull ?? '')
        as String;
  }

  static String getErrorStr(dynamic e) {
    if (kDebugMode) {
      print(StackTrace.current.toString());
    }

    if (e == null || e.toString().isEmpty) {
      return 'Serverdan javob kelmadi';
    }

    if (e is DioException) {
      if (e.response != null) {
        final data = e.response!.data;
        final statusCode = e.response!.statusCode!;

        debugPrint(data.toString());
        debugPrint(statusCode.toString());

        if (data is Map<String, dynamic>) {
          final rawMessage = data['message'];
          debugPrint(rawMessage);
          if (rawMessage is Map<String, dynamic> &&
              _isLocalizedMap(rawMessage)) {
            final localized = _extractLocalized(rawMessage);
            if (localized.isNotEmpty) return localized;
          }

          if (rawMessage is String && rawMessage.isNotEmpty) {
            return '$statusCode: $rawMessage';
          }

          final fallback = data['error'] ?? data['detail'] ?? data['errors'];
          if (fallback != null) {
            return '$statusCode: $fallback';
          }
        }

        if (statusCode >= 500) {
          return 'Server ishlamayapti';
        }

        return '$statusCode: ${e.response!.statusMessage}\n$data';
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return 'Internet mavjud emas';

        default:
          return '$e';
      }
    }

    return '$e';
  }

  static void showError(String message) {
    ToastHelper.error(message);
  }
}

class LocaleHelper {
  const LocaleHelper._();

  static String? extractLocalized(Map<String, dynamic> map, Locale locale) {
    final lang = locale.languageCode;
    final country = locale.countryCode?.toLowerCase();

    if (locale.scriptCode == 'Cyrl' && map['uz_cyr'] != null) {
      return map['uz_cyr'] as String?;
    }

    if (lang == 'kaa' || country == 'qq') {
      return (map['qq'] ?? map['ru'] ?? map['en']) as String?;
    }

    return (map[lang] ?? map['en']) as String?;
  }
}

String getError(dynamic e) => ErrorHelper.getErrorStr(e);

void showError(dynamic e) => ErrorHelper.showError(e);
