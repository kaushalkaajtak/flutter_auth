class OtpRequest {
  String? _id;
  String? _otp;

  OtpRequest({required String id, required String otp}) {
    this._id = id;
    this._otp = otp;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  String? get otp => _otp;

  set otp(String? otp) => _otp = otp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = _id;
    data['otp'] = _otp;
    return data;
  }
}


