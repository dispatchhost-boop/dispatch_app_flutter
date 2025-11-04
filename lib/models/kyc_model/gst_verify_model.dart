class GstVerificationModel {
  bool? success;
  String? gstin;
  String? tradeName;
  String? constitutionOfBusiness;
  String? natureOfBusinessActivities;
  String? address;
  String? message;

  GstVerificationModel(
      {this.success,
        this.gstin,
        this.tradeName,
        this.constitutionOfBusiness,
        this.natureOfBusinessActivities,
        this.address,
        this.message});

  GstVerificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    gstin = json['gstin'];
    tradeName = json['tradeName'];
    constitutionOfBusiness = json['constitutionOfBusiness'];
    natureOfBusinessActivities = json['natureOfBusinessActivities'];
    address = json['address'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['gstin'] = this.gstin;
    data['tradeName'] = this.tradeName;
    data['constitutionOfBusiness'] = this.constitutionOfBusiness;
    data['natureOfBusinessActivities'] = this.natureOfBusinessActivities;
    data['address'] = this.address;
    data['message'] = this.message;
    return data;
  }
}
