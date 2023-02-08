import 'package:flutter_auth/src/repos/auth_repo.dart';
import 'package:flutter_auth/src/views/auth_view/state/auth_cubit.dart';
import 'package:flutter_auth/src/utils/service/login_service.dart';
import 'package:flutter_auth/src/views/otp_view/state/otp_cubit.dart';
import 'package:flutter_auth/src/views/otp_view/state/otp_receiver_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// Class to locate the instance of objects already created in memory.
class Locator {
  /// Getit is used to have the functionality of locator class
  final GetIt _getIt = GetIt.instance;

  /// internal constructor of [Locator] class
  Locator._internal();

  /// static instance of locator class.
  static Locator i = Locator._internal();

  /// locates the object if present in memory.
  /// takes type `T` as the object type to find.
  T locate<T extends Object>() {
    return _getIt.get<T>();
  }

  /// registering the objects lazyly.
  void registerLocators(
      {List<String>? googleScopes, String? fbScopes, required String baseUrl}) {
    if (!_getIt.isRegistered<AuthCubit>()) {
      _getIt.registerLazySingleton<AuthCubit>(
        () => AuthCubit(_getIt.get<LoginService>()),
      );
      _getIt.registerLazySingleton<OtpReceiverCubit>(
        () => OtpReceiverCubit(_getIt.get<LoginService>()),
      );
      _getIt.registerLazySingleton<OtpCubit>(
        () => OtpCubit(service: _getIt.get<LoginService>()),
      );
      _getIt.registerLazySingleton<LoginService>(
          () => LoginService(_getIt.get<AuthRepo>(), googleScopes, fbScopes));
      _getIt.registerLazySingleton(
        () => AuthRepo(_getIt.get<Dio>()),
      );
      _getIt.registerLazySingleton<Dio>(
        () => Dio(BaseOptions(baseUrl: baseUrl)),
      );
    }
  }
}
