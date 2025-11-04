class ShipmentDataModel {
  int? totalOrders;
  int? readyToDispatch;
  int? readyToDispatchPost;
  int? inTransit;
  int? delivered;
  int? rto;
  int? rtoInTransit;
  int? outForDelivery;
  int? ndr;
  Percent? percent;
  AppliedFilters? appliedFilters;

  ShipmentDataModel(
      {this.totalOrders,
        this.readyToDispatch,
        this.readyToDispatchPost,
        this.inTransit,
        this.delivered,
        this.rto,
        this.rtoInTransit,
        this.outForDelivery,
        this.ndr,
        this.percent,
        this.appliedFilters});

  ShipmentDataModel.fromJson(Map<String, dynamic> json) {
    totalOrders = json['totalOrders'];
    readyToDispatch = json['readyToDispatch'];
    readyToDispatchPost = json['readyToDispatchPost'];
    inTransit = json['inTransit'];
    delivered = json['delivered'];
    rto = json['rto'];
    rtoInTransit = json['rtoInTransit'];
    outForDelivery = json['outForDelivery'];
    ndr = json['ndr'];
    percent =
    json['percent'] != null ? new Percent.fromJson(json['percent']) : null;
    appliedFilters = json['appliedFilters'] != null
        ? new AppliedFilters.fromJson(json['appliedFilters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalOrders'] = this.totalOrders;
    data['readyToDispatch'] = this.readyToDispatch;
    data['readyToDispatchPost'] = this.readyToDispatchPost;
    data['inTransit'] = this.inTransit;
    data['delivered'] = this.delivered;
    data['rto'] = this.rto;
    data['rtoInTransit'] = this.rtoInTransit;
    data['outForDelivery'] = this.outForDelivery;
    data['ndr'] = this.ndr;
    if (this.percent != null) {
      data['percent'] = this.percent!.toJson();
    }
    if (this.appliedFilters != null) {
      data['appliedFilters'] = this.appliedFilters!.toJson();
    }
    return data;
  }
}

class Percent {
  dynamic readyToDispatch;
  dynamic readyToDispatchPost;
  dynamic inTransit;
  dynamic delivered;
  dynamic rto;
  dynamic rtoInTransit;
  dynamic outForDelivery;
  dynamic ndr;

  Percent(
      {this.readyToDispatch,
        this.readyToDispatchPost,
        this.inTransit,
        this.delivered,
        this.rto,
        this.rtoInTransit,
        this.outForDelivery,
        this.ndr});

  Percent.fromJson(Map<String, dynamic> json) {
    readyToDispatch = json['readyToDispatch'];
    readyToDispatchPost = json['readyToDispatchPost'];
    inTransit = json['inTransit'];
    delivered = json['delivered'];
    rto = json['rto'];
    rtoInTransit = json['rtoInTransit'];
    outForDelivery = json['outForDelivery'];
    ndr = json['ndr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readyToDispatch'] = this.readyToDispatch;
    data['readyToDispatchPost'] = this.readyToDispatchPost;
    data['inTransit'] = this.inTransit;
    data['delivered'] = this.delivered;
    data['rto'] = this.rto;
    data['rtoInTransit'] = this.rtoInTransit;
    data['outForDelivery'] = this.outForDelivery;
    data['ndr'] = this.ndr;
    return data;
  }
}

class AppliedFilters {
  String? domain;
  String? courierType;
  Date? date;
  String? paymentMode;
  String? destinationZone;
  String? taggedApi;

  AppliedFilters(
      {this.domain,
        this.courierType,
        this.date,
        this.paymentMode,
        this.destinationZone,
        this.taggedApi});

  AppliedFilters.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    courierType = json['courier_type'];
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    paymentMode = json['payment_mode'];
    destinationZone = json['destination_zone'];
    taggedApi = json['tagged_api'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain'] = this.domain;
    data['courier_type'] = this.courierType;
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    data['payment_mode'] = this.paymentMode;
    data['destination_zone'] = this.destinationZone;
    data['tagged_api'] = this.taggedApi;
    return data;
  }
}

class Date {
  String? from;
  String? to;

  Date({this.from, this.to});

  Date.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
