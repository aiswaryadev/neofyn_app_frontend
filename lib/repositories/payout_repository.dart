// lib/repositories/payout_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class PayoutRepository {
  final ApiClient _client = ApiClient();

  /// Get bank list for payout
  Future<ApiResponse<List<Map<String, dynamic>>>> getBanks() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/payout/banks',
      fromJson: (data) => data,
    );
    final banks = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: banks);
  }

  /// Get purpose list
  Future<ApiResponse<List<Map<String, dynamic>>>> getPurposes() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/payout/purposes',
      fromJson: (data) => data,
    );
    final purposes = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: purposes);
  }

  /// Get states for payout
  Future<ApiResponse<List<Map<String, dynamic>>>> getStates() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/payout/states',
      fromJson: (data) => data,
    );
    final states = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: states);
  }

  /// Initiate payout
  Future<ApiResponse<Map<String, dynamic>>> initiatePayout(
      Map<String, dynamic> data) async {
    return _client.post(
      '/payout/initiate',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Get payout status by merchant reference ID
  Future<ApiResponse<Map<String, dynamic>>> getStatus(
      String merchantRefId) async {
    return _client.get(
      '/payout/status/$merchantRefId',
      fromJson: (data) => data,
    );
  }

  /// Get payout history
  Future<ApiResponse<List<Map<String, dynamic>>>> getHistory() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/payout/history',
      fromJson: (data) => data,
    );
    final history = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: history);
  }

  /// Get beneficiaries for a user
  Future<ApiResponse<List<Map<String, dynamic>>>> getBeneficiaries(
      String userId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/beneficiary/$userId',
      fromJson: (data) => data,
    );
    final beneficiaries = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: beneficiaries);
  }

  /// Save (add/update) beneficiary
  Future<ApiResponse<Map<String, dynamic>>> saveBeneficiary(
      Map<String, dynamic> data) async {
    return _client.post(
      '/beneficiary',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Delete beneficiary
  Future<ApiResponse<void>> deleteBeneficiary(String id) async {
    await _client.delete('/beneficiary/$id');
    return ApiResponse(success: true);
  }
}