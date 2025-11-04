// class SignInModel {
//   String? redirect;
//   String? message;
//   String? error;
//
//   SignInModel({this.redirect, this.message});
//
//   SignInModel.fromJson(Map<String, dynamic> json) {
//     redirect = json['redirect'];
//     message = json['message'];
//     error = json['error'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['redirect'] = this.redirect;
//     data['message'] = this.message;
//     data['error'] = this.error;
//     return data;
//   }
// }


class SignInModel {
  String? message;
  String? redirect;
  dynamic segmentType;
  String? redirectReason;
  String? token;
  bool? isKycVerified;

  SignInModel(
      {this.message,
        this.redirect,
        this.segmentType,
        this.redirectReason,
        this.token,
        this.isKycVerified});

  SignInModel.fromJson(Map<String, dynamic> json) {
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
