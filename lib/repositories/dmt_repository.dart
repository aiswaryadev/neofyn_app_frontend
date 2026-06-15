// lib/repositories/dmt_repository.dart
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class DmtRepository {
  final ApiClient _client = ApiClient();

  /// Agent login
  Future<ApiResponse<Map<String, dynamic>>> agentLogin(
      String mobile, String pan) async {
    return _client.post(
      '/agent/login',
      data: {'agentMobile': mobile, 'agentPan': pan},
      fromJson: (data) => data,
    );
  }

  /// Agent registration
  Future<ApiResponse<Map<String, dynamic>>> registerAgent(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/agent/register',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Fetch DMT states
  Future<ApiResponse<List<Map<String, dynamic>>>> getStates() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/dmt/states',
      fromJson: (data) => data,
    );
    final states = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: states);
  }

  /// Fetch cities by state code
  Future<ApiResponse<List<Map<String, dynamic>>>> getCities(
      String stateCode) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/dmt/cities',
      queryParameters: {'stateCode': stateCode},
      fromJson: (data) => data,
    );
    final cities = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: cities);
  }

  /// Fetch DMT banks
  Future<ApiResponse<List<Map<String, dynamic>>>> getBanks() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/dmt/banks',
      fromJson: (data) => data,
    );
    final banks = (response.rawData?['data'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        [];
    return ApiResponse(success: true, data: banks);
  }

  /// Check sender (lookup by mobile)
  Future<ApiResponse<Map<String, dynamic>>> checkSender(String mobile) async {
    return _client.post(
      '/dmt/beneficiary/list',
      data: {
        'senderMobileNo': mobile,
        'pageNumber': 1,
        'pageSize': 10,
      },
      fromJson: (data) => data,
    );
  }

  /// Register sender
  Future<ApiResponse<Map<String, dynamic>>> registerSender(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/sender/register',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Send OTP for sender verification
  Future<ApiResponse<Map<String, dynamic>>> sendOtp(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/sender/retrigger-otp',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Verify OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/sender/verify-otp',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Get beneficiary list
  Future<ApiResponse<Map<String, dynamic>>> getBeneficiaryList(
      String senderMobile,
      {int pageNumber = 1, int pageSize = 10}) async {
    return _client.post(
      '/dmt/beneficiary/list',
      data: {
        'senderMobileNo': senderMobile,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
      fromJson: (data) => data,
    );
  }

  /// Register beneficiary
  Future<ApiResponse<Map<String, dynamic>>> registerBeneficiary(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/beneficiary/register',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Perform penny drop verification
  Future<ApiResponse<Map<String, dynamic>>> performPennyDrop(
      String accountNo, String ifsc) async {
    return _client.post(
      '/dmt/penny-drop',
      data: {
        'beneficiaryAccountNumber': accountNo,
        'beneficiaryIFSC': ifsc,
      },
      fromJson: (data) => data,
    );
  }

  /// Send money (DMT transaction)
  Future<ApiResponse<Map<String, dynamic>>> sendMoney(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/transaction',
      data: data,
      fromJson: (data) => data,
    );
  }

  /// Resend transaction OTP
  Future<ApiResponse<Map<String, dynamic>>> resendTransactionOtp(
      String beneAccId) async {
    return _client.post(
      '/dmt/otp/resend',
      data: {'beneAccId': beneAccId},
      fromJson: (data) => data,
    );
  }

  /// Sync beneficiary with local database
  Future<ApiResponse<Map<String, dynamic>>> syncBeneficiaryWithLocalDb(
      Map<String, dynamic> data) async {
    return _client.post(
      '/dmt/beneficiary/sync-local',
      data: data,
      fromJson: (data) => data,
    );
  }
}