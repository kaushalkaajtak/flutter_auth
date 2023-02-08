import 'dart:io';
import 'package:flutter_auth/src/models/login_response.dart';
import 'package:flutter_auth/src/utils/service/otp_service.dart';
import 'package:flutter_auth/src/utils/widgets/reg_button.dart';
import 'package:flutter_auth/src/utils/widgets/title_widget.dart';
import 'package:flutter_auth/src/views/auth_view/state/auth_cubit.dart';
import 'package:flutter_auth/src/views/auth_view/state/auth_state.dart';
import 'package:flutter_auth/src/utils/widgets/auth_button.dart';
import 'package:flutter_auth/src/gen/assets.gen.dart';
import 'package:flutter_auth/src/consts/strings.dart';
import 'package:flutter_auth/src/views/otp_view/state/otp_state.dart';
import 'package:flutter_auth/src/views/otp_view/view/otp_receiver_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../otp_view/state/otp_cubit.dart';

class AuthView extends StatefulWidget {
  /// widget to be used as a header if provided defaults to welcome text
  final Widget? headerWidget;

  /// widget to be used as a footer if provided defaults to empty Container
  final Widget? footerWidget;

  final bool enableGoogleAuth;
  final bool enableFacebookAuth;
  final bool enableOtpAuth;

  /// available for ios only
  final bool enableAppleAuth;

  /// returns a user model if login has been succesfull
  final void Function(UserModel userModel) onloginSuccess;

  /// to enable skip
  final bool isSkipVisible;

  /// skip text
  final String skipText;

  /// skip callback
  final void Function() onSkip;

  final void Function(String message) onfailure;

  const AuthView({
    super.key,
    required this.onloginSuccess,
    this.headerWidget,
    this.footerWidget,
    this.enableGoogleAuth = true,
    this.enableFacebookAuth = true,
    this.enableOtpAuth = true,
    this.enableAppleAuth = true,
    required this.onfailure,
    required this.isSkipVisible,
    required this.onSkip,
    required this.skipText,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  String? _mobileError;
  String countryCode = '+91';
  String phoneNumber = '';
  bool isvalidated = false;

  final _phoneController = TextEditingController();
  @override
  void initState() {
    OtpService.otpListener((data) {
      if (data.keys.contains('number')) {
        if (data['number'] != null) {
          _phoneController.text = data['number'].toString().substring(3);
          phoneNumber = _phoneController.text;
          _mobileChangedListener(phoneNumber);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getting instance of authCubit
    var cubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Visibility(
              visible: widget.isSkipVisible,
              child: GestureDetector(
                onTap: widget.onSkip,
                child: Row(
                  children: [
                    Text(
                      widget.skipText,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // if authentication has canceled
          if (state is AuthCanceled) {
            widget.onfailure(state.message);
          }

          // if there is some error like: server side, internet issue etc.
          else if (state is AuthError) {
            widget.onfailure(state.message);
          }
        },
        child: BlocListener<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is OtpSent) {
              var model = context.read<OtpCubit>().userModel;
              if (model != null) {
                if (Platform.isAndroid) {
                  OtpService.requestSmsRead();
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpReceiverBuilder(
                        number: phoneNumber,
                        headerWidget: widget.headerWidget,
                        userModel: model,
                        onloginSuccess: widget.onloginSuccess),
                  ),
                );
              }
            }
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              TitleWidget(
                  headerWidget: widget.headerWidget,
                  description:
                      'Join us to access all the best\nfeatures that enhance your essential daily\n crime news',
                  title: 'Login or Register'),
              Column(
                children: [
                  if (widget.enableOtpAuth)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            decoration: const InputDecoration(
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                constraints: BoxConstraints(
                                    maxWidth: 267, maxHeight: 45)),
                            controller: _phoneController,
                            onChanged: (value) {
                              phoneNumber = _phoneController.text;
                              _mobileChangedListener(phoneNumber);
                            },
                            onTap: () {
                              if (Platform.isAndroid) {
                                if (_phoneController.text.isEmpty) {
                                  OtpService.getPhoneNumberHint();
                                }
                              }
                            },
                          ),
                        ),
                        if (_mobileError != null && _mobileError!.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              Text(_mobileError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            ],
                          ),
                        const SizedBox(height: 32),
                        RegularButton(
                          isActive: isvalidated,
                          ontap: () {
                            context.read<OtpCubit>().requestOtp(phoneNumber);
                          },
                          name: 'Verify OTP to Proceed',
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 307,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'OR',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  AuthButton(
                    margin: const EdgeInsets.only(top: 5),
                    isVisible: widget.enableFacebookAuth,
                    image: Assets.icons.facebook,
                    buttonText: Strings.facebook,
                    ontap: () async {
                      await cubit.facebookLogin();

                      // saving user model in a variable for better null check syntax
                      var userModel = cubit.userModel;
                      var successCallback = widget.onloginSuccess;

                      // checks if success call is provided and given that user has successfull
                      // logged in it invoks the callback with user model.
                      if (userModel != null) {
                        successCallback(userModel);
                      }
                    },
                  ),
                  AuthButton(
                    isVisible: widget.enableGoogleAuth,
                    margin: const EdgeInsets.only(top: 5),
                    image: Assets.icons.google,
                    buttonText: Strings.google,
                    ontap: () async {
                      await cubit.googleLogin();

                      // saving user model in a variable for better null check syntax
                      var userModel = cubit.userModel;
                      var successCallback = widget.onloginSuccess;

                      // checks if success call is provided and given that user has successfull
                      // logged in it invoks the callback with user model.

                      if (userModel != null) {
                        successCallback(userModel);
                      }
                    },
                  ),
                  AuthButton(
                    margin: const EdgeInsets.only(top: 5),
                    isVisible: Platform.isIOS && widget.enableAppleAuth,
                    image: Assets.icons.apple,
                    buttonText: Strings.apple,
                    ontap: () async {
                      await cubit.appleLogin();

                      // saving user model in a variable for better null check syntax
                      var userModel = cubit.userModel;
                      var successCallback = widget.onloginSuccess;

                      // checks if success call is provided and given that user has successfull
                      // logged in it invoks the callback with user model.
                      if (userModel != null) {
                        successCallback(userModel);
                      }
                    },
                  ),
                ],
              ),
              widget.footerWidget ?? Container()
            ],
          ),
        ),
      ),
    );
  }

  void _mobileChangedListener(String phone) {
    setState(() {
      _mobileError = validatePhone(phone);
      if (_mobileError == null || _mobileError == '') {
        isvalidated = true;
      } else {
        isvalidated = false;
      }
    });
  }

  String? validatePhone(String value) {
    Pattern pattern = r'^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$';

    RegExp regex = RegExp(pattern as String);

    if (value.trim().isEmpty) {
      return 'Please enter your mobile number';
      // return "Empty phone number";
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    } else {
      return null;
    }
  }
}
