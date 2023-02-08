import 'package:flutter_auth/src/models/login_response.dart';
import 'package:flutter_auth/src/utils/service/locater.dart';

import 'package:flutter_auth/src/views/otp_view/state/otp_receiver_cubit.dart';
import 'package:flutter_auth/src/views/otp_view/view/otp_reciever.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class OtpReceiverBuilder extends StatelessWidget {
  final Widget? headerWidget;
  final String number;
  final void Function(UserModel userModel)? onloginSuccess;
  final UserModel userModel;
  const OtpReceiverBuilder(
      {super.key,
      required this.userModel,
      this.onloginSuccess,
      this.headerWidget,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Locator.i.locate<OtpReceiverCubit>(),
      child: OtpReceiver(
        userModel: userModel,
        onloginSuccess: onloginSuccess,
        headerWidget: headerWidget,
        number: number,
      ),
    );
  }
}
