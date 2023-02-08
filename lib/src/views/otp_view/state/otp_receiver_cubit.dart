import 'package:flutter_auth/src/utils/auth_exception/auth_exception.dart';
import 'package:flutter_auth/src/utils/service/login_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/otp_request.dart';
import '../../../models/resend_request.dart';
import 'otp_receiver_state.dart';

class OtpReceiverCubit extends Cubit<OtpReceiverState> {
  final LoginService service;

  OtpReceiverCubit(
    this.service,
  ) : super(ReceiverInitial());

  Future<void> verifyOtp(String userId, String otp) async {
    emit(ReceiverLoading());
    try {
      var userModel = await service.verifyOtp(OtpRequest(id: userId, otp: otp));

      emit(OtpVerified(userModel));
    } on AuthException catch (e) {
      emit(ReceiverError(e.message, DateTime.now()));
    } catch (e) {
      emit(ReceiverError(e.toString(), DateTime.now()));
    }
  }

  Future<void> resendOtp(String userId) async {
    try {
      var result = await service.resendOtp(ResendOtpRequest(id: userId));
      if (result) {
        emit(ResentOtp());
      }
    } on AuthException catch (e) {
      emit(ReceiverError(e.message, DateTime.now()));
    } catch (e) {
      emit(ReceiverError(e.toString(), DateTime.now()));
    }
  }
}
