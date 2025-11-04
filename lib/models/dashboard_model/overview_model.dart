class DashboardOverviewModel {
  TablesUsed? tablesUsed;
  BusinessInsightObj? businessInsightObj;
  List<OrderSplitByPaymentMode>? orderSplitByPaymentMode;
  List<ShipmentSplitByShippingMode>? shipmentSplitByShippingMode;
  List<ShipmentSplitByCourier>? shipmentSplitByCourier;
  OrderJsonResponse? orderJsonResponse;
  ValueJsonResponse? valueJsonResponse;
  List<ShipmentSplitByWeight>? shipmentSplitByWeight;
  List<OrderSplitAcrossTopStates>? orderSplitAcrossTopStates;
  List<DeliveryPerformance>? deliveryPerformance;

  DashboardOverviewModel(
      {this.tablesUsed,
        this.businessInsightObj,
        this.orderSplitByPaymentMode,
        this.shipmentSplitByShippingMode,
        this.shipmentSplitByCourier,
        this.orderJsonResponse,
        this.valueJsonResponse,
        this.shipmentSplitByWeight,
        this.orderSplitAcrossTopStates,
        this.deliveryPerformance});

  DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    tablesUsed = json['tablesUsed'] != null
        ? new TablesUsed.fromJson(json['tablesUsed'])
        : null;
    businessInsightObj = json['businessInsightObj'] != null
        ? new BusinessInsightObj.fromJson(json['businessInsightObj'])
        : null;
    if (json['orderSplitByPaymentMode'] != null) {
      orderSplitByPaymentMode = <OrderSplitByPaymentMode>[];
      json['orderSplitByPaymentMode'].forEach((v) {
        orderSplitByPaymentMode!.add(new OrderSplitByPaymentMode.fromJson(v));
      });
    }
    if (json['shipmentSplitByShippingMode'] != null) {
      shipmentSplitByShippingMode = <ShipmentSplitByShippingMode>[];
      json['shipmentSplitByShippingMode'].forEach((v) {
        shipmentSplitByShippingMode!
            .add(new ShipmentSplitByShippingMode.fromJson(v));
      });
    }
    if (json['shipmentSplitByCourier'] != null) {
      shipmentSplitByCourier = <ShipmentSplitByCourier>[];
      json['shipmentSplitByCourier'].forEach((v) {
        shipmentSplitByCourier!.add(new ShipmentSplitByCourier.fromJson(v));
      });
    }
    orderJsonResponse = json['orderJsonResponse'] != null
        ? new OrderJsonResponse.fromJson(json['orderJsonResponse'])
        : null;
    valueJsonResponse = json['valueJsonResponse'] != null
        ? new ValueJsonResponse.fromJson(json['valueJsonResponse'])
        : null;
    if (json['ShipmentSplitByWeight'] != null) {
      shipmentSplitByWeight = <ShipmentSplitByWeight>[];
      json['ShipmentSplitByWeight'].forEach((v) {
        shipmentSplitByWeight!.add(new ShipmentSplitByWeight.fromJson(v));
      });
    }
    if (json['OrderSplitAcrossTopStates'] != null) {
      orderSplitAcrossTopStates = <OrderSplitAcrossTopStates>[];
      json['OrderSplitAcrossTopStates'].forEach((v) {
        orderSplitAcrossTopStates!
            .add(new OrderSplitAcrossTopStates.fromJson(v));
      });
    }
    if (json['DeliveryPerformance'] != null) {
      deliveryPerformance = <DeliveryPerformance>[];
      json['DeliveryPerformance'].forEach((v) {
        deliveryPerformance!.add(new DeliveryPerformance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tablesUsed != null) {
      data['tablesUsed'] = this.tablesUsed!.toJson();
    }
    if (this.businessInsightObj != null) {
      data['businessInsightObj'] = this.businessInsightObj!.toJson();
    }
    if (this.orderSplitByPaymentMode != null) {
      data['orderSplitByPaymentMode'] =
          this.orderSplitByPaymentMode!.map((v) => v.toJson()).toList();
    }
    if (this.shipmentSplitByShippingMode != null) {
      data['shipmentSplitByShippingMode'] =
          this.shipmentSplitByShippingMode!.map((v) => v.toJson()).toList();
    }
    if (this.shipmentSplitByCourier != null) {
      data['shipmentSplitByCourier'] =
          this.shipmentSplitByCourier!.map((v) => v.toJson()).toList();
    }
    if (this.orderJsonResponse != null) {
      data['orderJsonResponse'] = this.orderJsonResponse!.toJson();
    }
    if (this.valueJsonResponse != null) {
      data['valueJsonResponse'] = this.valueJsonResponse!.toJson();
    }
    if (this.shipmentSplitByWeight != null) {
      data['ShipmentSplitByWeight'] =
          this.shipmentSplitByWeight!.map((v) => v.toJson()).toList();
    }
    if (this.orderSplitAcrossTopStates != null) {
      data['OrderSplitAcrossTopStates'] =
          this.orderSplitAcrossTopStates!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryPerformance != null) {
      data['DeliveryPerformance'] =
          this.deliveryPerformance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TablesUsed {
  String? orders;
  String? lr;
  String? consignee;

  TablesUsed({this.orders, this.lr, this.consignee});

  TablesUsed.fromJson(Map<String, dynamic> json) {
    orders = json['orders'];
    lr = json['lr'];
    consignee = json['consignee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orders'] = this.orders;
    data['lr'] = this.lr;
    data['consignee'] = this.consignee;
    return data;
  }
}

class BusinessInsightObj {
  dynamic currentAvgOrders;
  dynamic prevAvgOrders;
  dynamic currentAvgValue;
  dynamic prevAvgValue;
  int? orderChangePct;
  int? valueChangePct;

  BusinessInsightObj(
      {this.currentAvgOrders,
        this.prevAvgOrders,
        this.currentAvgValue,
        this.prevAvgValue,
        this.orderChangePct,
        this.valueChangePct});

  BusinessInsightObj.fromJson(Map<String, dynamic> json) {
    currentAvgOrders = json['currentAvgOrders'];
    prevAvgOrders = json['prevAvgOrders'];
    currentAvgValue = json['currentAvgValue'];
    prevAvgValue = json['prevAvgValue'];
    orderChangePct = json['orderChangePct'];
    valueChangePct = json['valueChangePct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentAvgOrders'] = this.currentAvgOrders;
    data['prevAvgOrders'] = this.prevAvgOrders;
    data['currentAvgValue'] = this.currentAvgValue;
    data['prevAvgValue'] = this.prevAvgValue;
    data['orderChangePct'] = this.orderChangePct;
    data['valueChangePct'] = this.valueChangePct;
    return data;
  }
}

class OrderSplitByPaymentMode {
  String? paymentMode;
  int? total;

  OrderSplitByPaymentMode({this.paymentMode, this.total});

  OrderSplitByPaymentMode.fromJson(Map<String, dynamic> json) {
    paymentMode = json['payment_mode'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_mode'] = this.paymentMode;
    data['total'] = this.total;
    return data;
  }
}

class ShipmentSplitByShippingMode {
  String? shippingMode;
  int? total;

  ShipmentSplitByShippingMode({this.shippingMode, this.total});

  ShipmentSplitByShippingMode.fromJson(Map<String, dynamic> json) {
    shippingMode = json['shipping_mode'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipping_mode'] = this.shippingMode;
    data['total'] = this.total;
    return data;
  }
}

class ShipmentSplitByCourier {
  String? courierName;
  int? total;
  String? imageUrl;

  ShipmentSplitByCourier({this.courierName, this.total, this.imageUrl});

  ShipmentSplitByCourier.fromJson(Map<String, dynamic> json) {
    courierName = json['courier_name'];
    total = json['total'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courier_name'] = this.courierName;
    data['total'] = this.total;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

class OrderJsonResponse {
  TodayOrders? todayOrders;
  TodayOrders? weekOrders;
  TodayOrders? monthOrders;
  TodayOrders? quarterOrders;

  OrderJsonResponse(
      {this.todayOrders,
        this.weekOrders,
        this.monthOrders,
        this.quarterOrders});

  OrderJsonResponse.fromJson(Map<String, dynamic> json) {
    todayOrders = json['todayOrders'] != null
        ? new TodayOrders.fromJson(json['todayOrders'])
        : null;
    weekOrders = json['weekOrders'] != null
        ? new TodayOrders.fromJson(json['weekOrders'])
        : null;
    monthOrders = json['monthOrders'] != null
        ? new TodayOrders.fromJson(json['monthOrders'])
        : null;
    quarterOrders = json['quarterOrders'] != null
        ? new TodayOrders.fromJson(json['quarterOrders'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todayOrders != null) {
      data['todayOrders'] = this.todayOrders!.toJson();
    }
    if (this.weekOrders != null) {
      data['weekOrders'] = this.weekOrders!.toJson();
    }
    if (this.monthOrders != null) {
      data['monthOrders'] = this.monthOrders!.toJson();
    }
    if (this.quarterOrders != null) {
      data['quarterOrders'] = this.quarterOrders!.toJson();
    }
    return data;
  }
}

class TodayOrders {
  int? count;
  int? change;
  dynamic percentage;

  TodayOrders({this.count, this.change, this.percentage});

  TodayOrders.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    change = json['change'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['change'] = this.change;
    data['percentage'] = this.percentage;
    return data;
  }
}

class ValueJsonResponse {
  TodayValue? todayValue;
  TodayValue? weekValue;
  TodayValue? monthValue;
  TodayValue? quarterValue;

  ValueJsonResponse(
      {this.todayValue, this.weekValue, this.monthValue, this.quarterValue});

  ValueJsonResponse.fromJson(Map<String, dynamic> json) {
    todayValue = json['todayValue'] != null
        ? new TodayValue.fromJson(json['todayValue'])
        : null;
    weekValue = json['weekValue'] != null
        ? new TodayValue.fromJson(json['weekValue'])
        : null;
    monthValue = json['monthValue'] != null
        ? new TodayValue.fromJson(json['monthValue'])
        : null;
    quarterValue = json['quarterValue'] != null
        ? new TodayValue.fromJson(json['quarterValue'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todayValue != null) {
      data['todayValue'] = this.todayValue!.toJson();
    }
    if (this.weekValue != null) {
      data['weekValue'] = this.weekValue!.toJson();
    }
    if (this.monthValue != null) {
      data['monthValue'] = this.monthValue!.toJson();
    }
    if (this.quarterValue != null) {
      data['quarterValue'] = this.quarterValue!.toJson();
    }
    return data;
  }
}

class TodayValue {
  int? value;
  int? change;
  dynamic percentage;

  TodayValue({this.value, this.change, this.percentage});

  TodayValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    change = json['change'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['change'] = this.change;
    data['percentage'] = this.percentage;
    return data;
  }
}

class ShipmentSplitByWeight {
  String? weightBucket;
  int? total;

  ShipmentSplitByWeight({this.weightBucket, this.total});

  ShipmentSplitByWeight.fromJson(Map<String, dynamic> json) {
    weightBucket = json['weight_bucket'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_bucket'] = this.weightBucket;
    data['total'] = this.total;
    return data;
  }
}

class OrderSplitAcrossTopStates {
  String? state;
  int? totalOrders;

  OrderSplitAcrossTopStates({this.state, this.totalOrders});

  OrderSplitAcrossTopStates.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    totalOrders = json['total_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['total_orders'] = this.totalOrders;
    return data;
  }
}

class DeliveryPerformance {
  String? onTime;
  String? delay;
  String? rto;

  DeliveryPerformance({this.onTime, this.delay, this.rto});

  DeliveryPerformance.fromJson(Map<String, dynamic> json) {
    onTime = json['on_time'];
    delay = json['delay'];
    rto = json['rto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['on_time'] = this.onTime;
    data['delay'] = this.delay;
    data['rto'] = this.rto;
    return data;
  }
}