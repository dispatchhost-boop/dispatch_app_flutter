class ClientsListModel {
  List<Clients>? clients;

  ClientsListModel({this.clients});

  ClientsListModel.fromJson(Map<String, dynamic> json) {
    if (json['clients'] != null) {
      clients = <Clients>[];
      json['clients'].forEach((v) {
        clients!.add(new Clients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.clients != null) {
      data['clients'] = this.clients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clients {
  int? id;
  int? parentId;
  int? level;
  String? fullName;
  String? companyName;

  Clients(
      {this.id, this.parentId, this.level, this.fullName, this.companyName});

  Clients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    level = json['level'];
    fullName = json['full_name'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['level'] = this.level;
    data['full_name'] = this.fullName;
    data['company_name'] = this.companyName;
    return data;
  }
}
