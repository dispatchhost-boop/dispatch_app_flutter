class ClientKycDataModel {
  bool? ok;
  UserData? userData;

  ClientKycDataModel({this.ok, this.userData});

  ClientKycDataModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  Null? organization;
  String? email;
  String? firstName;
  String? phoneNo;
  int? isKycSubmitted;
  int? isKycVerified;

  UserData(
      {this.id,
        this.organization,
        this.email,
        this.firstName,
        this.phoneNo,
        this.isKycSubmitted,
        this.isKycVerified});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organization = json['organization'];
    email = json['email'];
    firstName = json['first_name'];
    phoneNo = json['phone_no'];
    isKycSubmitted = json['is_kyc_submitted'];
    isKycVerified = json['is_kyc_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization'] = this.organization;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['phone_no'] = this.phoneNo;
    data['is_kyc_submitted'] = this.isKycSubmitted;
    data['is_kyc_verified'] = this.isKycVerified;
    return data;
  }
}
