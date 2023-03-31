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
  final String? screen1Description;
  final String? screen1Title;
  final bool showBottomLine;

  /// Auth token - If want to verify phoneNumber only.
  final String? authToken;
  final bool isPhoneVerifyFlow;

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

  final void Function(String message) onfailure;

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
  }) {
    // registering dependencies
    Locator.i.registerLocators(
      googleScopes: googleScopes,
      fbScopes: fbScopes,
      baseUrl: baseUrl,
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
        onfailure: onfailure,
        isSkipVisible: isSkipVisible,
        skipText: skipText,
        onSkip: onSkip,
      ),
    );
  }
}
