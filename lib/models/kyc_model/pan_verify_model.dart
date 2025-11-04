import 'package:dispatch/const/debug_config.dart';

class PanVerifyModel {
  Data? data;

  PanVerifyModel({this.data});

  PanVerifyModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Msg? msg;
  int? status;
  String? errorMsg;

  Data({this.msg, this.status, this.errorMsg});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['msg'] is Map<String, dynamic>) {
      msg = Msg.fromJson(json['msg']);
    } else if (json['msg'] is String) {
      errorMsg = json['msg'].toString();
    } else {
      msg = null;
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (msg != null) {
      data['msg'] = msg!.toJson();
    } else if (errorMsg != null) {
      data['msg'] = errorMsg;
    } else {
      data['msg'] = null;
    }
    data['status'] = status;
    return data;
  }
}


class Msg {
  String? lastUpdate;
  String? name;
  String? nameOnTheCard;
  String? panNumber;
  String? sTATUS;
  String? statusDescription;
  String? panHolderStatusType;
  int? sourceId;

  Msg(
      {this.lastUpdate,
        this.name,
        this.nameOnTheCard,
        this.panNumber,
        this.sTATUS,
        this.statusDescription,
        this.panHolderStatusType,
        this.sourceId});

  Msg.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['LastUpdate'];
    name = json['Name'];
    nameOnTheCard = json['NameOnTheCard'];
    panNumber = json['PanNumber'];
    sTATUS = json['STATUS'];
    statusDescription = json['StatusDescription'];
    panHolderStatusType = json['panHolderStatusType'];
    sourceId = json['source_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LastUpdate'] = this.lastUpdate;
    data['Name'] = this.name;
    data['NameOnTheCard'] = this.nameOnTheCard;
    data['PanNumber'] = this.panNumber;
    data['STATUS'] = this.sTATUS;
    data['StatusDescription'] = this.statusDescription;
    data['panHolderStatusType'] = this.panHolderStatusType;
    data['source_id'] = this.sourceId;
    return data;
  }
}
