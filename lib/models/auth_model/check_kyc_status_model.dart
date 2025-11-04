class CheckKycStatusModel {
  String? id;
  String? createdAt;
  String? status;
  String? customerIdentifier;
  String? referenceId;
  String? transactionId;
  int? expireInDays;
  bool? reminderRegistered;
  AccessToken? accessToken;
  String? workflowName;
  bool? autoApproved;
  String? templateId;

  CheckKycStatusModel(
      {this.id,
      this.createdAt,
      this.status,
      this.customerIdentifier,
      this.referenceId,
      this.transactionId,
      this.expireInDays,
      this.reminderRegistered,
      this.accessToken,
      this.workflowName,
      this.autoApproved,
      this.templateId});

  CheckKycStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    status = json['status'];
    customerIdentifier = json['customer_identifier'];
    referenceId = json['reference_id'];
    transactionId = json['transaction_id'];
    expireInDays = json['expire_in_days'];
    reminderRegistered = json['reminder_registered'];
    accessToken = json['access_token'] != null
        ? new AccessToken.fromJson(json['access_token'])
        : null;
    workflowName = json['workflow_name'];
    autoApproved = json['auto_approved'];
    templateId = json['template_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['customer_identifier'] = this.customerIdentifier;
    data['reference_id'] = this.referenceId;
    data['transaction_id'] = this.transactionId;
    data['expire_in_days'] = this.expireInDays;
    data['reminder_registered'] = this.reminderRegistered;
    if (this.accessToken != null) {
      data['access_token'] = this.accessToken!.toJson();
    }
    data['workflow_name'] = this.workflowName;
    data['auto_approved'] = this.autoApproved;
    data['template_id'] = this.templateId;
    return data;
  }
}

class AccessToken {
  String? entityId;
  String? id;
  String? validTill;
  String? createdAt;

  AccessToken({this.entityId, this.id, this.validTill, this.createdAt});

  AccessToken.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    id = json['id'];
    validTill = json['valid_till'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['id'] = this.id;
    data['valid_till'] = this.validTill;
    data['created_at'] = this.createdAt;
    return data;
  }
}
