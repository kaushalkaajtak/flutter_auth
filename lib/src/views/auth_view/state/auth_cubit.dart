 
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/login_response.dart';
import '../../../utils/auth_exception/auth_exception.dart';
import '../../../utils/service/login_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._service) : super(AuthInitial());

  UserModel? userModel;
  final LoginService _service;

  Future<void> googleLogin() async {
    // setting up null if user tries to login again
    // then the sucess might get calls even if current request has failed.
    userModel = null;
    emit(AuthLoading());
    await signOut();
    try {
      userModel = await _service.googleAuth();
      if (userModel != null) {
        emit(Authenticated(userModel!));
      } else {
        emit(AuthCanceled('Cancelled login with Google'));
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> appleLogin() async {
    // setting up null if user tries to login again
    // then the sucess might get calls even if current request has failed.
    userModel = null;
    emit(AuthLoading());
    try {
      userModel = await _service.appleAuth();
      if (userModel != null) {
        emit(Authenticated(userModel!));
      } else {
        emit(AuthCanceled('Cancelled login with Apple'));
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> facebookLogin() async {
    // setting up null if user tries to login again
    // then the sucess might get calls even if current request has failed.
    userModel = null;
    emit(AuthLoading());
    try {
      userModel = await _service.facebookAuth();
      if (userModel != null) {
        emit(Authenticated(userModel!));
      } else {
        emit(AuthCanceled('Cancelled login with Facebook'));
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    // setting up null if user tries to login again
    // then the sucess might get calls even if current request has failed.
    userModel = null;
    try {
      await _service.signOut();
      emit(LoggedOut());
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
