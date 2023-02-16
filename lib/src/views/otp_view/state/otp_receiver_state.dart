import 'package:equatable/equatable.dart';

import '../../../models/login_response.dart';

abstract class OtpReceiverState extends Equatable {}

class ReceiverInitial extends OtpReceiverState {
  @override
  List<Object?> get props => [];
}

class ReceiverLoading extends OtpReceiverState {
  final DateTime dateTime;

  ReceiverLoading(this.dateTime);
  @override
  List<Object?> get props => [dateTime];
}

class ResentOtp extends OtpReceiverState {
  final DateTime dateTime;

  ResentOtp(this.dateTime);
  @override
  List<Object?> get props => [dateTime];
}

class OtpVerified extends OtpReceiverState {
  final UserModel userModel;
  final DateTime dateTime;

  OtpVerified(this.userModel, this.dateTime);

  @override
  List<Object?> get props => [userModel, dateTime];
}

class ReceiverError extends OtpReceiverState {
  final String messae;
  final DateTime dateTime;

  ReceiverError(this.messae, this.dateTime);

  @override
  List<Object?> get props => [messae, dateTime];
}
