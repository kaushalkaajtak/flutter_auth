class ResendOtpRequest {
  String? _id;

  ResendOtpRequest({required String id}) {
    this._id = id;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    return data;
  }
}
