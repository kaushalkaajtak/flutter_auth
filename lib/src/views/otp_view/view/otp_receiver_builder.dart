 
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/login_response.dart';
import '../../../utils/service/locater.dart';
import '../state/otp_receiver_cubit.dart';
import 'otp_reciever.dart';

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
