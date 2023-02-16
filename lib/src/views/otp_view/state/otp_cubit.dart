import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/login_response.dart';
import '../../../utils/auth_exception/auth_exception.dart';
import '../../../utils/service/login_service.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final LoginService service;
  OtpCubit({required this.service}) : super(OtpInitial());

  UserModel? userModel;

  Future<void> requestOtp(String phoneNumber) async {
    // setting up null if user tries to login again
    // then the sucess might get calls even if current request has failed.
    userModel = null;
    emit(OtpLoading(DateTime.now()));

    try {
      userModel = await service.phoneAuth(phoneNumber);
      if (userModel == null) {
        emit(OtpError('Some error occured.', DateTime.now()));
      } else {
        emit(OtpSent(DateTime.now()));
      }
    } on AuthException catch (e) {
      emit(OtpError(e.message, DateTime.now()));
    } catch (e) {
      emit(OtpError(e.toString(), DateTime.now()));
    }
  }
}
