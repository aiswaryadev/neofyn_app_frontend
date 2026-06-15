// lib/core/network/api_exception.dart

/// Typed API Exception for consistent error handling across the app
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;
  final bool isUnauthorized;
  final bool isNotFound;
  final bool isServerError;
  final dynamic rawData;

  ApiException({
    required this.message,
    this.statusCode,
    this.isNetworkError = false,
    this.isUnauthorized = false,
    this.isNotFound = false,
    this.isServerError = false,
    this.rawData,
  });

  /// Get user-friendly message for display
  String get userMessage {
    if (isNetworkError) return 'No internet connection. Please check your network.';
    if (isUnauthorized) return 'Session expired. Please login again.';
    if (isServerError) return 'Server error. Please try again later.';
    if (isNotFound) return 'The requested resource was not found.';
    return message;
  }

  @override
  String toString() =>
      'ApiException(message: $message, statusCode: $statusCode, '
          'isNetworkError: $isNetworkError, isUnauthorized: $isUnauthorized)';
}