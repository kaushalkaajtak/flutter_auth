import 'dart:developer';

import 'package:flutter/services.dart';

abstract class OtpService {
  static const MethodChannel _methodChannel = MethodChannel('flutter_auth');
  static Future<void> getPhoneNumberHint() async {
    try {
      await _methodChannel.invokeMethod('requestPhoneNumber');
    } catch (error, stackTrace) {
      log('invokeException', error: error, level: 1, stackTrace: stackTrace);
    }
  }

  static void otpListener(Function(Map<String, dynamic> data) callback) async {
    _methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'selectedPhoneNumber':
          callback({
            'number': call.arguments,
          });
          break;

        case 'receivedSms':
          callback({
            'otp': call.arguments,
          });
          break;

        default:
          break;
      }
    });
  }

  static void requestSmsRead() async {
    try {
      await _methodChannel.invokeMethod('requestSms');
    } catch (error, stackTrace) {
      log('invokeException', error: error, level: 1, stackTrace: stackTrace);
    }
  }
}
