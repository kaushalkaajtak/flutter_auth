import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../models/login_response.dart';
import '../../../utils/service/locater.dart';
import '../../otp_view/state/otp_cubit.dart';
import '../state/auth_cubit.dart';
import 'auth_view.dart';

class AuthBuilder extends StatelessWidget {
  /// base url for server api
  final String baseUrl;

  /// add customized description for login screen.
  final String? screen1Description;

  /// add customized title for login screen.
  final String? screen1Title;

  /// used to disable the seperation between otp and social login
  final bool showBottomLine;

  /// Auth token - If want to verify phoneNumber only.
  final String? authToken;

  /// used to disable the seperation between otp and social
  /// login if user has used this screen as phone verification flow.
  final bool isPhoneVerifyFlow;
  final Map<String, dynamic>? headers;

  /// defaults to email scope only
  final List<String>? googleScopes;

  /// defaults to "name,email,picture.width(200)"
  final String? fbScopes;

  /// widget to be used as a header if provided defaults to welcome text
  final Widget? headerWidget;

  /// widget to be used as a footer if provided defaults to empty Container
  final Widget? footerWidget;

  final bool enableGoogleAuth;
  final bool enableFacebookAuth;
  final bool enableOtpAuth;

  /// available for ios only
  final bool enableAppleAuth;

  /// to enable skip
  final bool isSkipVisible;

  /// skip text
  final String skipText;

  /// skip callback
  final void Function() onSkip;

  /// returns a user model if login has been succesfull
  final void Function(UserModel userModel) onloginSuccess;

  /// failure callback with string message.
  final void Function(String message) onfailure;

  /// enable/disable support for international numbers.
  final bool onlySupportIndianNo;

  final bool enableWhatsapp;

  final TextStyle? titleTextStyle;

  final TextStyle? descriptionTextStyle;

  final String? loginApi;
  final String? otpVerifyApi;
  final String? otpResendApi;

  AuthBuilder({
    super.key,
    this.googleScopes,
    required this.onloginSuccess,
    this.headerWidget,
    this.footerWidget,
    this.fbScopes,
    this.enableOtpAuth = true,
    this.enableAppleAuth = true,
    this.enableGoogleAuth = true,
    this.enableFacebookAuth = true,
    this.headers,
    required this.onfailure,
    required this.baseUrl,
    required this.isSkipVisible,
    required this.skipText,
    required this.onSkip,
    this.isPhoneVerifyFlow = false,
    this.screen1Description,
    this.screen1Title,
    this.authToken,
    this.showBottomLine = true,
    this.onlySupportIndianNo = true,
    required this.enableWhatsapp,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.loginApi,
    this.otpVerifyApi,
    this.otpResendApi,
  }) {
    Firebase.initializeApp();
    // registering dependencies
    Locator.i.registerLocators(
      googleScopes: googleScopes,
      fbScopes: fbScopes,
      baseUrl: baseUrl,
      headers: headers,
      loginApi: loginApi,
      otpResendApi: otpResendApi,
      otpVerifyApi: otpVerifyApi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: Locator.i.locate<AuthCubit>(),
        ),
        BlocProvider.value(
          value: Locator.i.locate<OtpCubit>(),
        )
      ],
      child: AuthView(
        enableWhatsApp: enableWhatsapp,
        onlySupportIndianNo: onlySupportIndianNo,
        authToken: authToken,
        showBottomLine: showBottomLine,
        screen1Description: screen1Description,
        screen1Title: screen1Title,
        isPhoneVerifyFlow: isPhoneVerifyFlow,
        headerWidget: headerWidget,
        footerWidget: footerWidget,
        enableOtpAuth: enableOtpAuth,
        onloginSuccess: onloginSuccess,
        enableAppleAuth: enableAppleAuth,
        enableGoogleAuth: enableGoogleAuth,
        enableFacebookAuth: enableFacebookAuth,
        titleTextStyle: titleTextStyle,
        descriptionTextStyle: descriptionTextStyle,
        onfailure: onfailure,
        isSkipVisible: isSkipVisible,
        skipText: skipText,
        onSkip: onSkip,
      ),
    );
  }
}
