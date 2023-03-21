import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/otp_request.dart';
import '../../models/resend_request.dart';
import '../../repos/auth_repo.dart';
import '../auth_exception/auth_exception.dart';

class LoginService {
  final AuthRepo _authRepo;
  final List<String>? _scopes;
  final String? _fbScopes;

  late GoogleSignIn _googleSignIn;

  LoginService(this._authRepo, [this._scopes, this._fbScopes]) {
    _googleSignIn = GoogleSignIn(scopes: _scopes ?? ['email']);
  }
  Future<UserModel?> googleAuth() async {
    // login initiated

    try {
      var googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) return null;
      // server authentication
      var response = await _authRepo.serverAuthentication(
        request: LoginRequest(
          email: googleSignInAccount.email,
          googleId: googleSignInAccount.id,
          loginType: LoginRequest.googleType,
          fullname: googleSignInAccount.displayName,
          profileImage: googleSignInAccount.photoUrl,
          deviceId: await LoginRequest.deviceIdentifier(),
        ),
      );
      if (response.status ?? false) {
        return response.result;
      } else {
        throw AuthException(message: response.message ?? "Unknown error");
      }
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<UserModel?> facebookAuth() async {
    UserModel? userModel;
    try {
      final LoginResult result = await FacebookAuth.i.login(
        loginBehavior: LoginBehavior.webOnly,
      );

      // login successfull
      switch (result.status) {
        case LoginStatus.success:
          Map<String, dynamic> userData = await FacebookAuth.i.getUserData(
            fields: _fbScopes ?? 'name,email,picture.width(200)',
          );
          // server authentication
          var response = await _authRepo.serverAuthentication(
            request: LoginRequest(
              email: userData['email'] ?? '',
              loginType: LoginRequest.facebookType,
              fullname: userData['name'] ?? '',
              facebookId: userData['id'] ?? '',
              profileImage: userData['picture']?['data']?['url'] ?? '',
              deviceId: await LoginRequest.deviceIdentifier(),
            ),
          );

          if (response.status ?? false) {
            userModel = response.result;
          }

          break;

        case LoginStatus.cancelled:
          break;

        case LoginStatus.failed:
          break;

        default:
          break;
      }

      return userModel;
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<UserModel?> appleAuth() async {
    // login initiated
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // server authentication
      var response = await _authRepo.serverAuthentication(
          request: LoginRequest(
        email: credential.email ?? '',
        fullname: credential.givenName,
        appleId: credential.userIdentifier.toString(),
        deviceId: await LoginRequest.deviceIdentifier(),
        loginType: LoginRequest.appleType,
      ));

      if (response.status ?? false) {
        return response.result;
      } else {
        throw AuthException(message: response.message ?? "Unknown error");
      }
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          break;

        case AuthorizationErrorCode.failed:
          throw AuthException(message: e.message);

        default:
          throw AuthException(message: e.message);
      }

      return null;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<UserModel?> phoneAuth(
      {required String phoneNumber,
      required String countyCode,
      required String e164Key,
      required bool numberUpdate}) async {
    // otp requesting

    try {
      var response = await _authRepo.serverAuthentication(
          request: LoginRequest(
        phoneNumber: phoneNumber,
        countryCode: countyCode,
        e164Key: e164Key,
        numberUpdate: numberUpdate,
        deviceId: await LoginRequest.deviceIdentifier(),
        loginType: LoginRequest.otpType,
      ));

      if (response.status ?? false) {
        return response.result;
      } else {
        throw AuthException(message: response.message ?? "Unknown error");
      }
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<UserModel> verifyOtp(OtpRequest request) async {
    try {
      var response = await _authRepo.verifyOtp(request);

      if (response.status ?? false) {
        return response.result!;
      } else {
        throw AuthException(message: response.message ?? "Unknown error");
      }
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<bool> resendOtp(ResendOtpRequest resendOtpRequest) async {
    try {
      var response = await _authRepo.resendOtpRequest(resendOtpRequest);
      if (response.status ?? false) {
        return true;
      } else {
        throw AuthException(message: response.message ?? "Unknown error");
      }
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
