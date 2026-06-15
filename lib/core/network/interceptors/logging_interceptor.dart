// lib/core/network/interceptors/logging_interceptor.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Beautiful console logging for ALL HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  static const _line = '──────────────────────────────────────────────────────────';
  static int _requestCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestCount++;
    final requestId = _requestCount;

    debugPrint('');
    debugPrint(_line);
    debugPrint('📤 REQUEST #$requestId');
    debugPrint('📍 ${options.method} ${options.uri}');
    debugPrint('🔑 Auth: ${options.headers['Authorization'] != null ? "YES ✅" : "NO ❌"}');
    debugPrint('⏱️ Timeout: ${options.connectTimeout?.inSeconds ?? 15}s');

    if (options.data != null) {
      _printPrettyJson('📦 Body', options.data);
    }

    if (options.queryParameters.isNotEmpty) {
      debugPrint('🔍 Query: ${options.queryParameters}');
    }

    debugPrint(_line);

    options.extra['startTime'] = DateTime.now();
    options.extra['requestId'] = requestId;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.requestOptions.extra['requestId'] as int? ?? 0;
    final startTime =
        response.requestOptions.extra['startTime'] as DateTime? ?? DateTime.now();
    final duration = DateTime.now().difference(startTime);

    final statusCode = response.statusCode ?? 0;
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '⚠️';

    debugPrint('');
    debugPrint(_line);
    debugPrint('$emoji RESPONSE #$requestId [${response.requestOptions.method}]');
    debugPrint('📍 ${response.requestOptions.uri}');
    debugPrint('📊 Status: $statusCode');
    debugPrint('⏱️ Duration: ${duration.inMilliseconds}ms');

    if (response.data != null) {
      final dataStr = response.data.toString();
      if (dataStr.length > 2000) {
        debugPrint('📥 Body: ${dataStr.substring(0, 2000)}... [TRUNCATED]');
      } else {
        _printPrettyJson('📥 Body', response.data);
      }
    }

    debugPrint(_line);

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = err.requestOptions.extra['requestId'] as int? ?? 0;
    final startTime =
        err.requestOptions.extra['startTime'] as DateTime? ?? DateTime.now();
    final duration = DateTime.now().difference(startTime);

    debugPrint('');
    debugPrint(_line);
    debugPrint('❌ ERROR #$requestId [${err.requestOptions.method}]');
    debugPrint('📍 ${err.requestOptions.uri}');
    debugPrint('📊 Status: ${err.response?.statusCode}');
    debugPrint('⏱️ Duration: ${duration.inMilliseconds}ms');
    debugPrint('💬 Message: ${err.message}');
    debugPrint('🔍 Type: ${err.type}');

    if (err.response?.data != null) {
      _printPrettyJson('📥 Error Body', err.response!.data);
    }

    debugPrint(_line);

    handler.next(err);
  }

  void _printPrettyJson(String label, dynamic data) {
    try {
      final encoder = const JsonEncoder.withIndent('  ');
      final prettyString = encoder.convert(data is Map ? data : {'value': data});
      debugPrint('$label: $prettyString');
    } catch (_) {
      debugPrint('$label: $data');
    }
  }
}