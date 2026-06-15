// lib/repositories/wallet_repository.dart
import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class WalletRepository {
  final ApiClient _client = ApiClient();

  /// Get main wallet balance
  Future<ApiResponse<Map<String, dynamic>>> getMainBalance(
      String userId) async {
    return _client.get(
      '/wallet/main/$userId',
      fromJson: (data) => data,
    );
  }

  /// Get AEPS wallet balance
  Future<ApiResponse<Map<String, dynamic>>> getAepsBalance(
      String userId) async {
    return _client.get(
      '/wallet/aeps/$userId',
      fromJson: (data) => data,
    );
  }

  /// Get wallet stats (rewards, commission, CC balance)
  Future<ApiResponse<Map<String, dynamic>>> getStats(String userId) async {
    try {
      return await _client.get(
        '/wallet/stats/$userId',
        fromJson: (data) => data,
      );
    } catch (e) {
      // Return default stats if endpoint doesn't exist
      return ApiResponse(
        success: true,
        data: {
          'rewards': 0,
          'commission': 0,
          'ccBalance': 0,
        },
      );
    }
  }

  /// Get wallet ledger (transaction history)
  Future<ApiResponse<List<dynamic>>> getLedger(String userId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/wallet/ledger/$userId',
      fromJson: (data) => data,
    );
    final ledger = response.rawData?['ledger'] as List<dynamic>? ?? [];
    return ApiResponse(success: true, data: ledger);
  }

  /// Get fund requests
  Future<ApiResponse<List<dynamic>>> getFundRequests(String userId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/wallet/fund-requests/$userId',
      fromJson: (data) => data,
    );
    final requests = response.rawData?['requests'] as List<dynamic>? ?? [];
    return ApiResponse(success: true, data: requests);
  }

  /// Submit fund request with file upload
  Future<ApiResponse<Map<String, dynamic>>> submitFundRequest(
      FormData formData) async {
    return _client.upload(
      '/wallet/fund-request',
      formData: formData,
      fromJson: (data) => data,
    );
  }
}