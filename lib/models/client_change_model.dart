class ClientChangeModel {
  String? message;
  String? redirect;
  dynamic segmentType;
  String? redirectReason;
  String? token;
  bool? isKycVerified;

  ClientChangeModel(
      {this.message,
        this.redirect,
        this.segmentType,
        this.redirectReason,
        this.token,
        this.isKycVerified});

  ClientChangeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    redirect = json['redirect'];
    segmentType = json['segmentType'];
    redirectReason = json['redirectReason'];
    token = json['token'];
    isKycVerified = json['is_kyc_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['redirect'] = this.redirect;
    data['segmentType'] = this.segmentType;
    data['redirectReason'] = this.redirectReason;
    data['token'] = this.token;
    data['is_kyc_verified'] = this.isKycVerified;
    return data;
  }
}
