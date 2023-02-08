import 'package:flutter_auth/src/models/login_request.dart';
import 'package:flutter_auth/src/models/login_response.dart';
import 'package:flutter_auth/src/models/resend_request.dart';
import 'package:flutter_auth/src/consts/apis/api_consts.dart';
import 'package:flutter_auth/src/utils/auth_exception/auth_exception.dart';
import 'package:dio/dio.dart';
import '../models/otp_request.dart';

class AuthRepo {
  final Dio _dio;
  AuthRepo(this._dio);

  Future<LoginResponse> serverAuthentication(
      {required LoginRequest request}) async {
    try {
      var response = await _dio.post(
        ApiConsts.LOGIN,
        data: request.toJson(),
      );

      var responseMap = response.data as Map<String, dynamic>;
      return LoginResponse.fromJson(responseMap);
    } on DioError catch (e) {
      throw AuthException(message: e.message);
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
      throw AuthException(message: e.message);
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
      throw AuthException(message: e.message);
    } on FormatException catch (e) {
      throw AuthException(message: e.message);
    }
  }
}
