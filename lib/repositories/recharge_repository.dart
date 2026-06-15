// lib/repositories/recharge_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class RechargeRepository {
  final ApiClient _client = ApiClient();

  /// Get recharge operators
  Future<ApiResponse<List<Map<String, dynamic>>>> getOperators(
      String serviceType) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/recharge/operators',
      data: {'serviceType': serviceType},
      fromJson: (data) => data,
    );
    final operators = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: operators);
  }

  /// Process recharge
  Future<ApiResponse<Map<String, dynamic>>> processRecharge(
      Map<String, dynamic> data) async {
    return _client.post(
      '/recharge',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Get recharge history
  Future<ApiResponse<List<Map<String, dynamic>>>> getHistory() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/recharge/history',
      fromJson: (data) => data,
    );
    final history = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: history);
  }

  /// Get recharge receipt
  Future<ApiResponse<Map<String, dynamic>>> getReceipt(int transactionId) async {
    return _client.get(
      '/recharge/receipt/$transactionId',
      fromJson: (data) => data,
    );
  }
}