// lib/repositories/aeps_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class AepsRepository {
  final ApiClient _client = ApiClient();

  /// Get bank list
  Future<ApiResponse<List<Map<String, dynamic>>>> getBanks() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/aeps/banks',
      fromJson: (data) => data,
    );
    final banks = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: banks);
  }

  /// Get states list
  Future<ApiResponse<List<Map<String, dynamic>>>> getStates() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/aeps/states',
      fromJson: (data) => data,
    );
    final states = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: states);
  }

  /// Get districts by state code
  Future<ApiResponse<List<Map<String, dynamic>>>> getDistricts(
      String stateCode) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/aeps/districts',
      data: {'stateCode': stateCode},
      fromJson: (data) => data,
    );
    final districts = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: districts);
  }

  /// Register merchant
  Future<ApiResponse<Map<String, dynamic>>> registerMerchant(
      Map<String, dynamic> data) async {
    return _client.post(
      '/aeps/merchant/register',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Send OTP
  Future<ApiResponse<Map<String, dynamic>>> sendOtp({
    required String merchantId,
    required String merchantRefId,
    String? pipe,
  }) async {
    return _client.post(
      '/aeps/merchant/send-otp',
      data: {
        'merchantId': merchantId,
        'merchantRefId': merchantRefId,
        'pipe': pipe ?? '1',
      },
      fromJson: (data) => data,
    );
  }

  /// Verify OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String merchantId,
    required String otp,
    required String merchantRefId,
    String? pipe,
  }) async {
    return _client.post(
      '/aeps/merchant/verify-otp',
      data: {
        'merchantId': merchantId,
        'otp': otp,
        'merchantRefId': merchantRefId,
        'pipe': pipe ?? '1',
      },
      fromJson: (data) => data,
    );
  }

  /// Perform 2FA
  Future<ApiResponse<Map<String, dynamic>>> perform2FA(
      Map<String, dynamic> data) async {
    return _client.post(
      '/aeps/2fa',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Execute AEPS transaction (cash withdrawal, balance enquiry, etc.)
  Future<ApiResponse<Map<String, dynamic>>> executeTransaction(
      Map<String, dynamic> data) async {
    return _client.post(
      '/aeps/transaction',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Get transaction status
  Future<ApiResponse<Map<String, dynamic>>> getTransactionStatus(
      String txnRefId) async {
    return _client.post(
      '/aeps/transaction/status',
      data: {'txnRefId': txnRefId},
      fromJson: (data) => data,
    );
  }

  /// Get AEPS history
  Future<ApiResponse<Map<String, dynamic>>> getHistory({
    int limit = 20,
    int offset = 0,
    required String userId,
  }) async {
    return _client.get(
      '/aeps/history',
      queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'userId': userId,
      },
      fromJson: (data) => data,
    );
  }

  /// Cash withdrawal
  Future<ApiResponse<Map<String, dynamic>>> cashWithdrawal(
      Map<String, dynamic> data) async {
    return _client.post(
      '/aeps/cash-withdrawal',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Balance enquiry
  Future<ApiResponse<Map<String, dynamic>>> balanceEnquiry(
      Map<String, dynamic> data) async {
    return _client.post(
      '/aeps/balance-enquiry',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Mini statement
  Future<ApiResponse<Map<String, dynamic>>> miniStatement(
      Map<String, dynamic> data) async {
    return _client.post(
      '/aeps/mini-statement',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Get AEPS wallet balance
  Future<ApiResponse<double>> getAepsBalance() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/aeps/wallet/balance',
      fromJson: (data) => data,
    );
    final balance =
        double.tryParse(response.rawData?['balance']?.toString() ?? '0') ?? 0;
    return ApiResponse(success: true, data: balance);
  }

  /// Move to main wallet
  Future<ApiResponse<Map<String, dynamic>>> moveToMainWallet(
      double amount) async {
    return _client.post(
      '/aeps/move-to-main',
      data: {'amount': amount},
      fromJson: (data) => data,
    );
  }
}