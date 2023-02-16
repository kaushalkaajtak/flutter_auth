import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {}

class OtpInitial extends OtpState {
  @override
  List<Object?> get props => [];
}

class OtpLoading extends OtpState {
  final DateTime dateTime;

  OtpLoading(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class OtpSent extends OtpState {
  final DateTime dateTime;

  OtpSent(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class OtpError extends OtpState {
  final String message;
  final DateTime dateTime;

  OtpError(this.message, this.dateTime);

  @override
  List<Object?> get props => [message, dateTime];
}
