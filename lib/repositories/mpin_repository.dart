// lib/repositories/mpin_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/network/api_response.dart';

class MpinRepository {
  final ApiClient _client = ApiClient();

  /// Set MPIN (first time)
  Future<ApiResponse<Map<String, dynamic>>> setMpin(String mpin) async {
    return _client.post(
      '/auth/set-mpin',
      data: {'mpin': mpin},
      fromJson: (data) => data,
    );
  }

  /// Verify MPIN
  Future<ApiResponse<bool>> verifyMpin(String mpin) async {
    try {
      await _client.post('/auth/verify-mpin', data: {'mpin': mpin});
      return ApiResponse(success: true, data: true);
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        return ApiResponse(success: false, data: false);
      }
      rethrow;
    }
  }

  /// Change MPIN
  Future<ApiResponse<Map<String, dynamic>>> changeMpin({
    required String currentMpin,
    required String newMpin,
  }) async {
    return _client.post(
      '/auth/change-mpin',
      data: {'currentMpin': currentMpin, 'newMpin': newMpin},
      fromJson: (data) => data,
    );
  }

  /// Check if MPIN is set
  Future<ApiResponse<bool>> isMpinSet() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/auth/mpin-status',
        fromJson: (data) => data,
      );
      return ApiResponse(
        success: response.success,
        data: response.rawData?['mpinSet'] == true,
      );
    } catch (e) {
      return ApiResponse(success: false, data: false);
    }
  }

  /// Clear MPIN locally
  Future<void> clearMpinStatus() async {
    // Local cleanup if needed
  }
}