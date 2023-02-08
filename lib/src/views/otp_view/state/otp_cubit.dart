import 'package:flutter_auth/src/models/login_response.dart';
import 'package:flutter_auth/src/utils/auth_exception/auth_exception.dart';
import 'package:flutter_auth/src/utils/service/login_service.dart';
import 'package:flutter_auth/src/views/otp_view/state/otp_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCubit extends Cubit<OtpState> {
  final LoginService service;
  OtpCubit({required this.service}) : super(OtpInitial());

  UserModel? userModel;

  Future<void> requestOtp(String phoneNumber) async {
    // setting up null if user tries to login again
    // then the sucess might get calls even if current request has failed.
    userModel = null;
    emit(OtpLoading());

    try {
      userModel = await service.phoneAuth(phoneNumber);
      if (userModel == null) {
        emit(OtpError('Some error occured.'));
      } else {
        emit(OtpSent());
      }
    } on AuthException catch (e) {
      emit(OtpError(e.message));
    } catch (e) {
      emit(OtpError(e.toString()));
    }
  }
}
