import 'dart:io';
import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/src/consts/auth_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../consts/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/login_response.dart';
import '../../../utils/service/otp_service.dart';
import '../../../utils/widgets/auth_button.dart';
import '../../../utils/widgets/reg_button.dart';
import '../../../utils/widgets/title_widget.dart';
import '../../otp_view/state/otp_cubit.dart';
import '../../otp_view/state/otp_state.dart';
import '../../otp_view/view/otp_receiver_builder.dart';
import '../state/auth_cubit.dart';
import '../state/auth_state.dart';

class AuthView extends StatefulWidget {
  /// widget to be used as a header if provided defaults to welcome text
  final Widget? headerWidget;

  /// widget to be used as a footer if provided defaults to empty Container
  final Widget? footerWidget;

  final bool isPhoneVerifyFlow;
  final String? screen1Description;
  final String? screen1Title;

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
    this.isPhoneVerifyFlow = false,
    this.screen1Description,
    this.screen1Title,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  String? _mobileError;
  String countryCode = '+91';
  String e164Key = '91-IN-0';
  String phoneNumber = '';
  bool isvalidated = false;
  bool clickedOnce = false;

  final _phoneController = TextEditingController();
  @override
  void initState() {
    OtpService.otpListener((data) {
      if (data.keys.contains('number')) {
        if (data['number'] != null) {
          countryCode = data['number'].toString().substring(0, 3);
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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    TitleWidget(
                      headerWidget: widget.headerWidget,
                      description: widget.screen1Description ??
                          'Join us to access all the best\nfeatures that enhance your essential daily\n crime news',
                      title: widget.screen1Title ?? 'Login or Register',
                    ),
                    Column(
                      children: [
                        if (widget.enableOtpAuth)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    favorite: ['IN', 'US'],
                                    showPhoneCode:
                                        true, // optional. Shows phone code before the country name.
                                    onSelect: (Country country) {
                                      countryCode = '+${country.phoneCode}';
                                      e164Key = country.e164Key;
                                      setState(() {});
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AuthColors
                                                .textFieldBorderColor),
                                        color: AuthColors.countryCodePicker,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            countryCode,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AuthColors.white,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 16,
                                            color: AuthColors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AuthColors
                                                .textFieldBorderColor),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 12,
                                        decoration: const InputDecoration(
                                          hintText: 'Mobile Number',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          constraints: BoxConstraints(
                                            maxWidth: 197,
                                            maxHeight: 45,
                                          ),
                                        ),
                                        controller: _phoneController,
                                        buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) {
                                          return SizedBox();
                                        },
                                        onChanged: (value) {
                                          phoneNumber = _phoneController.text;
                                          _mobileChangedListener(phoneNumber);
                                        },
                                        onTap: () {
                                          if (Platform.isAndroid &&
                                              !clickedOnce) {
                                            if (_phoneController.text.isEmpty) {
                                              OtpService.getPhoneNumberHint();
                                            }
                                            setState(() {
                                              clickedOnce = true;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_mobileError != null &&
                                  _mobileError!.isNotEmpty)
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
                                  context.read<OtpCubit>().requestOtp(
                                        countyCode: countryCode,
                                        e164Key: e164Key,
                                        phoneNumber: phoneNumber,
                                        numberUpdate: widget.isPhoneVerifyFlow,
                                      );
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
                  ],
                ),
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
    // Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

    // RegExp regex = RegExp(pattern as String);

    if (value.trim().isEmpty) {
      return 'Please enter your mobile number';
      // return "Empty phone number";
    }

    // else if (!regex.hasMatch(value)) {
    //   return 'Please enter a valid mobile number';
    // }
    else {
      return null;
    }
  }
}
