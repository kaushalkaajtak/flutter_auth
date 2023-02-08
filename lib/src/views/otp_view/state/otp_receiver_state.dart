import 'package:flutter_auth/src/models/login_response.dart';

abstract class OtpReceiverState {}

class ReceiverInitial extends OtpReceiverState {}

class ReceiverLoading extends OtpReceiverState {}

class ResentOtp extends OtpReceiverState {}

class OtpVerified extends OtpReceiverState {
  final UserModel userModel;

  OtpVerified(this.userModel);
}

class VerifyOtp extends OtpReceiverState {}

class ReceiverError extends OtpReceiverState {
  final String messae;

  ReceiverError(this.messae);
}
