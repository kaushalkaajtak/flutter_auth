 
import 'package:equatable/equatable.dart';

import '../../../models/login_response.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  AuthError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class AuthCanceled extends AuthState {
  final String message;

  AuthCanceled(this.message);
}

class LoggedOut extends AuthState {}

class Authenticated extends AuthState {
  final UserModel userModel;
  Authenticated(this.userModel);

  @override
  List<Object?> get props => [userModel];
}
