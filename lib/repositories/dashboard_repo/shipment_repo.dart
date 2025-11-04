import 'package:dispatch/api_client/web_api_provider/web_api_provider.dart';
import 'package:dispatch/models/dashboard_model/shipment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var shipmentRepo = Provider((ref)=> ShipmentRepo(ref.read(webApiProvider)));

class ShipmentRepo{
  late final WebApiProvider _ref;
  ShipmentRepo(this._ref);

  Future<ShipmentDataModel?> fetchShipmentData({required WidgetRef loaderRef, required Map<String, String> body,  required Map<String, String> clientDetails}) async{
    return await _ref.getShipmentData(body: body, loaderRef: loaderRef, clientDetails: clientDetails);
  }

}