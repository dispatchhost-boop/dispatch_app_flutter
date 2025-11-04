class SignUpModel {
  String? message;
  dynamic status;

  SignUpModel({this.message, this.status});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
