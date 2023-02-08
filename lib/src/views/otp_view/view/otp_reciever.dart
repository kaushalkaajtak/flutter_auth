import 'dart:async';
import 'dart:io';

import 'package:flutter_auth/src/gen/assets.gen.dart';
import 'package:flutter_auth/src/models/login_response.dart';
import 'package:flutter_auth/src/utils/service/otp_service.dart';
import 'package:flutter_auth/src/utils/widgets/reg_button.dart';

import 'package:flutter_auth/src/views/otp_view/state/otp_receiver_cubit.dart';
import 'package:flutter_auth/src/views/otp_view/state/otp_receiver_state.dart';

import 'package:flutter_auth/src/utils/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpReceiver extends StatefulWidget {
  final UserModel userModel;
  final Widget? headerWidget;
  final String number;
  final void Function(UserModel userModel)? onloginSuccess;
  const OtpReceiver(
      {super.key,
      required this.userModel,
      this.onloginSuccess,
      this.headerWidget,
      required this.number});

  @override
  State<OtpReceiver> createState() => _OtpReceiverState();
}

class _OtpReceiverState extends State<OtpReceiver> {
  String otpNumber = '';
  bool isvalidated = false;
  bool isButtonBlock = false;
  // TextEditingController _otpController = TextEditingController();
  late Timer _timer;
  bool resend = false;
  String? _mobileError;
  final bool _isLoading = false;

  final TextEditingController _otpTextEditController = TextEditingController();
  // late OTPInteractor _otpInteractor;

  Timer? _debounce;

  late int timerCounter;

  /// check value of _counter on 2 places
  int _counter = 59;
  @override
  void initState() {
    _startTimer();
    _registerListner();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<OtpReceiverCubit, OtpReceiverState>(
      listener: (context, state) {
        if (state is ReceiverError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.messae)));
        } else if (state is OtpVerified) {
          if (widget.onloginSuccess != null) {
            widget.onloginSuccess!(state.userModel);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: TitleWidget(
                      title: 'Verify Otp',
                      headerWidget: widget.headerWidget,
                      description:
                          'We’ve sent you a verification code to\n+91 ${widget.number}. Please enter the code to\nregister.',
                    )),
                    Container(
                      width: size.width * .8,
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom * .1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PinCodeTextField(
                            controller: _otpTextEditController,
                            appContext: context,
                            length: 5,
                            textStyle:
                                const TextStyle(fontSize: 22, height: 1.8),
                            obscureText: false,
                            animationType: AnimationType.fade,
                            blinkDuration: const Duration(milliseconds: 250),
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                borderWidth: .5,
                                fieldHeight: size.width * .12,
                                fieldWidth: size.width * .12,
                                inactiveFillColor: Colors.white,
                                activeFillColor: Colors.white,
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: Colors.grey,
                                selectedFillColor: Colors.white,
                                selectedColor: Theme.of(context).primaryColor),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            onCompleted: (v) {
                              setState(() {
                                isvalidated = true;
                              });
                            },
                            onChanged: (value) {
                              if (value.length < 5) {
                                setState(() {
                                  isvalidated = false;
                                });
                              }
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                          _timerSection(),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: _mobileError != null ? 2.0 : 5),
                              child: Visibility(
                                  visible: _mobileError != null,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Assets.icons.errorImage.image(height: 16),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          _mobileError ?? '',
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      )
                                    ],
                                  )))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * .06,
                    ),
                    RegularButton(
                        isActive: (_otpTextEditController.text.length == 5),
                        ontap: () {
                          context.read<OtpReceiverCubit>().verifyOtp(
                              widget.userModel.sId!,
                              _otpTextEditController.text);
                        },
                        name:
                            _isLoading ? "Verifying" : 'Verify OTP to Proceed'),
                  ],
                ),
              ),
              if (state is ReceiverLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _timerSection() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              if (!resend) return;
              setState(() {
                _counter = 59;
                resend = false;
              });

              var cubit = context.read<OtpReceiverCubit>();
              cubit.resendOtp(widget.userModel.sId!);

              if (Platform.isAndroid) {
                _registerListner();
              }
              _startTimer();
            },
            child: Text(
              'RESEND OTP',
              style: TextStyle(
                  color: resend ? Theme.of(context).primaryColor : Colors.grey,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          resend
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    '${0.toString().padLeft(2, '0')} : ${_counter.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_counter <= 0) {
            _timer.cancel();
            setState(() {
              resend = true;
            });
          } else {
            _counter--;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _registerListner() {
    OtpService.otpListener((data) {
      if (data.keys.contains('otp')) {
        if (data['otp'] != null) {
          _otpTextEditController.text = data['otp'].toString().split(" ").first;
        }
      }
    });
  }
}
