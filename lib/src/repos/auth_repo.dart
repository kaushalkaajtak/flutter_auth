import 'package:dio/dio.dart';
import '../consts/apis/api_consts.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/otp_request.dart';
import '../models/resend_request.dart';
import '../utils/auth_exception/auth_exception.dart';

class AuthRepo {
  final Dio _dio;
  AuthRepo(this._dio);

  Future<LoginResponse> serverAuthentication(
      {required LoginRequest request, String? token}) async {
    try {
      var response = await _dio.post(
        ApiConsts.LOGIN,
        data: request.toJson(),
        options: token != null
            ? Options(
                headers: {"Authorization": "Bearer $token"},
              )
            : null,
      );
      var responseMap = response.data as Map<String, dynamic>;
      return LoginResponse.fromJson(responseMap);
    } on DioError catch (e) {
      throw AuthException(message: e.response?.data['message'] ?? e.message);
    } on FormatException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  Future<LoginResponse> verifyOtp(OtpRequest request) async {
    try {
      var response = await _dio.put(
        ApiConsts.OTP_VERIFY,
        data: request.toJson(),
      );
      var responseMap = response.data as Map<String, dynamic>;
      return LoginResponse.fromJson(responseMap);
    } on DioError catch (e) {
      throw AuthException(message: e.response?.data['message'] ?? e.message);
    } on FormatException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  Future<LoginResponse> resendOtpRequest(
      ResendOtpRequest resendOtpRequest) async {
    try {
      var response = await _dio.put(
        ApiConsts.OTP_RESEND,
        data: resendOtpRequest.toJson(),
      );
      var responseMap = response.data as Map<String, dynamic>;
      return LoginResponse.fromJson(responseMap);
    } on DioError catch (e) {
      throw AuthException(message: e.response?.data['message'] ?? e.message);
    } on FormatException catch (e) {
      throw AuthException(message: e.message);
    }
  }
}
