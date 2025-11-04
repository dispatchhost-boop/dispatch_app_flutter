import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/models/dashboard_model/shipment_model.dart';
import 'package:dispatch/repositories/dashboard_repo/shipment_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/login_credentials/user_authentications.dart';
import 'filter_vm.dart';

class ShipmentViewModel{

  late final WidgetRef _ref;
  late final ShipmentRepo _repo;
  ShipmentViewModel(this._ref){
    _repo = _ref.read(shipmentRepo);
  }

  final selectedZone = StateProvider<String?>((ref) => null);
  final zonesList = StateProvider<List<Map<String, String>>>((ref)=>[
    {
      "id": "1",
      "zone": "Zone A"
    },{
      "id": "2",
      "zone": "Zone B"
    },{
      "id": "3",
      "zone": "Zone C"
    },{
      "id": "4",
      "zone": "Zone D"
    },{
      "id": "5",
      "zone": "Zone E"
    },
  ]);
  final shipmentData = StateProvider<ShipmentDataModel?>((ref)=> null);

  bool zoneOnChange(Map<String, String>? selectedObj) {
    if (selectedObj != null) {
      DebugConfig.debugLog('APsdasd :: $selectedObj');
      final id = selectedObj['id'] ?? '';
      _ref.read(selectedZone.notifier).state = id;

      return true;
    } else {
      _ref.read(selectedZone.notifier).state = null;
      return false;
    }
  }

  Future<ShipmentDataModel?> fetchShipmentData ({required WidgetRef loaderRef, required Map<String, String> body, required Map<String, String> clientDetails})async {
    final r = await _repo.fetchShipmentData(body: body, loaderRef: loaderRef, clientDetails: clientDetails);
    _ref.refresh(shipmentData.notifier).state = r;
    return r;
  }

}