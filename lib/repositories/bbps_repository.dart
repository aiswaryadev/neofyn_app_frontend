// lib/repositories/bbps_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class BbpsRepository {
  final ApiClient _client = ApiClient();

  /// Get BBPS biller categories
  Future<ApiResponse<List<Map<String, dynamic>>>> getCategories() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/bbps/categories',
      fromJson: (data) => data,
    );
    final categories = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: categories);
  }

  /// Get billers for a category
  Future<ApiResponse<List<Map<String, dynamic>>>> getBillers(
      String categoryId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/bbps/billers',
      queryParameters: {'categoryId': categoryId},
      fromJson: (data) => data,
    );
    final billers = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: billers);
  }

  /// Fetch bill details
  Future<ApiResponse<Map<String, dynamic>>> fetchBill({
    required String billerId,
    required String consumerNumber,
    Map<String, dynamic>? additionalParams,
  }) async {
    return _client.post(
      '/bbps/fetch-bill',
      data: {
        'billerId': billerId,
        'consumerNumber': consumerNumber,
        'additionalParams': additionalParams ?? {},
      },
      fromJson: (data) => data,
    );
  }

  /// Pay bill
  Future<ApiResponse<Map<String, dynamic>>> payBill({
    required String merchantRefId,
    required Map<String, dynamic> fetchBillResult,
    required double amount,
  }) async {
    return _client.post(
      '/bbps/pay-bill',
      data: {
        'merchantRefId': merchantRefId,
        'fetchBillResult': fetchBillResult,
        'amount': amount,
      },
      fromJson: (data) => data,
    );
  }

  /// Check bill payment status
  Future<ApiResponse<Map<String, dynamic>>> checkStatus(
      String merchantRefId) async {
    return _client.get(
      '/bbps/status/$merchantRefId',
      fromJson: (data) => data,
    );
  }

  /// Get BBPS states
  Future<ApiResponse<List<Map<String, dynamic>>>> getStates() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/bbps/states',
      fromJson: (data) => data,
    );
    final states = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: states);
  }
}