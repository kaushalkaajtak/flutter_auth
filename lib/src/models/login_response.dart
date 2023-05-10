class LoginResponse {
  bool? status;
  String? message;
  UserModel? result;

  LoginResponse({this.status, this.message, this.result});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? UserModel.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class UserModel {
  String? sId;
  String? firstname;
  String? lastname;
  String? fullname;
  String? email;
  String? profileImage;
  dynamic phoneNumber;
  bool? isConfirmed;
  String? gender;
  String? location;
  String? latitude;
  String? longitude;
  String? role;
  bool? isActive;
  bool? isPushEnabled;
  bool? isEmailEnabled;
  bool? isMorningNewsEnabled;
  bool? isEveningNewsEnabled;
  int? loginType;
  String? deviceType;
  String? deviceId;
  String? deviceToken;
  String? token;
  bool? isNew;
  String? countryCode;
  String? e164Key;
  String? url;
  UserModel(
      {this.sId,
      this.firstname,
      this.lastname,
      this.fullname,
      this.email,
      this.profileImage,
      this.phoneNumber,
      this.isConfirmed,
      this.gender,
      this.location,
      this.latitude,
      this.longitude,
      this.role,
      this.isActive,
      this.isPushEnabled,
      this.isEmailEnabled,
      this.isMorningNewsEnabled,
      this.isEveningNewsEnabled,
      this.loginType,
      this.deviceType,
      this.deviceId,
      this.deviceToken,
      this.token,
      this.isNew,
      this.countryCode,
      this.e164Key,
      this.url});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    fullname = json['fullname'];
    email = json['email'];
    profileImage = json['profileImage'];
    phoneNumber = json['phoneNumber'];
    isConfirmed = json['isConfirmed'];
    gender = json['gender'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    role = json['role'];
    isActive = json['isActive'];
    isPushEnabled = json['isPushEnabled'];
    isEmailEnabled = json['isEmailEnabled'];
    isMorningNewsEnabled = json['isMorningNewsEnabled'];
    isEveningNewsEnabled = json['isEveningNewsEnabled'];
    loginType = json['loginType'];
    deviceType = json['deviceType'];
    deviceId = json['deviceId'];
    deviceToken = json['deviceToken'];
    token = json['token'];
    isNew = json['isNew'];
    countryCode = json['countryCode'];
    e164Key = json['e164Key'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['fullname'] = fullname;
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['phoneNumber'] = phoneNumber;
    data['isConfirmed'] = isConfirmed;
    data['gender'] = gender;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['role'] = role;
    data['isActive'] = isActive;
    data['isPushEnabled'] = isPushEnabled;
    data['isEmailEnabled'] = isEmailEnabled;
    data['isMorningNewsEnabled'] = isMorningNewsEnabled;
    data['isEveningNewsEnabled'] = isEveningNewsEnabled;
    data['loginType'] = loginType;
    data['deviceType'] = deviceType;
    data['deviceId'] = deviceId;
    data['deviceToken'] = deviceToken;
    data['token'] = token;
    data['isNew'] = isNew;
    data['countryCode'] = countryCode;
    data['e164Key'] = e164Key;
    data["url"] = url;
    return data;
  }
}
