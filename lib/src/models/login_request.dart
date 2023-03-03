import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import '../consts/strings.dart';

class LoginRequest {
  // required params
  /// specifies the type of login request:
  /// [googleType], [appleType], [facebookType], [otpType]
  final String loginType;

  /// phone auth values
  final String phoneNumber;
  final String countryCode;
  final String e164Key;

  final String email;

  /// social id for facebook
  final String facebookId;

  /// social id for google
  final String googleId;

  /// social id for apple
  final String appleId;

  // nullable types
  final String? cleverTapId;
  final String? fullname;
  final String? profileImage;

  // late initializations
  /// specifies device platform (android/ios)
  late String deviceType;

  /// device Id for specific platform and device
  final String? deviceId;

  LoginRequest({
    required this.loginType,
    this.phoneNumber = '',
    this.facebookId = '',
    this.googleId = '',
    this.appleId = '',
    this.fullname,
    this.profileImage,
    this.cleverTapId,
    this.deviceId,
    this.email = '',
    this.countryCode = '',
    this.e164Key = '',
  }) {
    deviceType = Platform.isAndroid ? Strings.android : Strings.ios;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginType'] = loginType;
    data['phoneNumber'] = phoneNumber;
    data['facebookId'] = facebookId;
    data['googleId'] = googleId;
    data['appleId'] = appleId;
    data['fullname'] = fullname;
    data['profileImage'] = profileImage;
    data['deviceType'] = deviceType;
    data['deviceId'] = deviceId;
    data['cleverTapId'] = cleverTapId;
    data['email'] = email;
    data['countyCode'] = countryCode;
    data['e164Key'] = e164Key;
    return data;
  }

  /// login type of google auth
  static const String googleType = "3";

  /// login type of apple auth
  static const String appleType = "4";

  /// login type of facebook auth
  static const String facebookType = "2";

  /// login type of otp auth
  static const String otpType = "1";

  ///
  /// Method to give device info which is used by backend to identify
  /// device.
  ///
  /// returns `Future` of `String?` as deviceId for both
  /// android and iOS only.
  /// return null for other platform types.
  static Future<String?> deviceIdentifier() async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      return null;
    }
  }
}
