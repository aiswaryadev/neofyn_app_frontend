// lib/core/network/interceptors/retry_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Auto-retry failed requests on network errors only
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;

    if (!shouldRetry) {
      return handler.next(err);
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      debugPrint('🔄 Max retries ($maxRetries) reached for: ${err.requestOptions.path}');
      return handler.next(err);
    }

    debugPrint('🔄 Retrying (${retryCount + 1}/$maxRetries): ${err.requestOptions.path}');

    err.requestOptions.extra['retryCount'] = retryCount + 1;

    await Future.delayed(retryDelay * (retryCount + 1));

    try {
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}