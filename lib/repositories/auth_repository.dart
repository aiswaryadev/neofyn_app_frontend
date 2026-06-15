// lib/repositories/auth_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/network/api_response.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  /// Login with phone and password
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String phone,
    required String password,
  }) async {
    return _client.post(
      '/auth/login',
      data: {'phone': phone, 'password': password},
      requiresAuth: false,
      fromJson: (data) => data,
    );
  }

  /// Register new user
  Future<ApiResponse<Map<String, dynamic>>> register(
      Map<String, dynamic> userData) async {
    return _client.post(
      '/auth/register',
      data: userData,
      requiresAuth: false,
      fromJson: (data) => data,
    );
  }

  /// Forgot password - request OTP
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword(String phone) async {
    return _client.post(
      '/auth/forgot-password',
      data: {'phone': phone},
      requiresAuth: false,
      fromJson: (data) => data,
    );
  }

  /// Reset password with OTP
  Future<ApiResponse<Map<String, dynamic>>> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    return _client.post(
      '/auth/reset-password',
      data: {'phone': phone, 'otp': otp, 'newPassword': newPassword},
      requiresAuth: false,
      fromJson: (data) => data,
    );
  }

  /// Get merchant by phone
  Future<ApiResponse<Map<String, dynamic>>> getMerchantByPhone(
      String phone) async {
    return _client.get(
      '/aeps/merchant/by-phone',
      queryParameters: {'phone': phone},
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
        message: response.message,
      );
    } catch (e) {
      return ApiResponse(success: false, data: false, message: e.toString());
    }
  }

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

  /// Set TPIN
  Future<ApiResponse<String?>> setTpin(String tpin) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/set-tpin',
      data: {'newTpin': tpin},
      fromJson: (data) => data,
    );
    return ApiResponse(
      success: response.success,
      data: response.rawData?['accessToken']?.toString(),
    );
  }

  /// Change TPIN
  Future<ApiResponse<Map<String, dynamic>>> changeTpin({
    required String currentTpin,
    required String newTpin,
  }) async {
    return _client.post(
      '/auth/change-tpin',
      data: {'currentTpin': currentTpin, 'newTpin': newTpin},
      fromJson: (data) => data,
    );
  }

  /// Verify TPIN
  Future<ApiResponse<bool>> verifyTpin(String tpin) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/auth/verify-tpin',
        data: {'tpin': tpin},
        fromJson: (data) => data,
      );
      return ApiResponse(
        success: response.success,
        data: response.rawData?['valid'] == true,
      );
    } catch (e) {
      return ApiResponse(success: false, data: false, message: e.toString());
    }
  }
}