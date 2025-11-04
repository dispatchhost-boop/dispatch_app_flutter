import 'package:dispatch/const/common_methods.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/const/loader/loader_controller.dart';
import 'package:dispatch/view_model/dashboard_vm/shipment_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/dashboard_model/shipment_model.dart';
import '../../services/login_credentials/user_authentications.dart';

class DashBoardFilterViewModel{
  late final WidgetRef _ref;
  DashBoardFilterViewModel(this._ref){

  }

  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();

  final quickRangeVal = StateProvider<String?>((ref)=>'1');
  final appliedFilterList = StateProvider<List<Map<String, String>>>((ref)=>[]);
  final selectedFiltersList = StateProvider<List<Map<String, String>>>((ref)=>[]);
  final selectedPaymentMode = StateProvider<String?>((ref) => '1');
  final paymentModeList = StateProvider<List<Map<String, String>>>((ref)=>[
    {"pay_id": "1", "pay_mode": "All"},
    {"pay_id": "2", "pay_mode": "Prepaid"},
    {"pay_id": "3", "pay_mode": "COD"}
  ]);

  final slctdDestination = StateProvider<String?>((ref) => '1');
  final destinationList = StateProvider<List<Map<String, String>>>((ref)=>[
    {"des_id": "1", "des": "All"},
    {"des_id": "2", "des": "North"},
    {"des_id": "3", "des": "South"},
    {"des_id": "4", "des": "East"},
    {"des_id": "5", "des": "West"},
    {"des_id": "6", "des": "Central"},
  ]);

  final slctdCourier = StateProvider<String?>((ref) => '1');
  final courierList = StateProvider<List<Map<String, String>>>((ref)=>[
    {"courier_id": "1", "courier": "All"},
    {"courier_id": "2", "courier": "Xpressbess"},
    {"courier_id": "3", "courier": "DTDC"},
    {"courier_id": "4", "courier": "Delhivery"},
  ]);

  bool quickRangeChange(
      Map<String, String>? selectedObj,) {
    if (selectedObj != null) {

      // update quickRangeVal
      final rangeId = selectedObj['range_id'] ?? '';
      _ref.read(quickRangeVal.notifier).state = rangeId;
      DebugConfig.debugLog('Select onjjg :: $selectedObj');
      // update selected filters (DO NOT refresh here)
      _ref.read(selectedFiltersList.notifier).update((state) {
        return _updateFilterList(state, {
          "range_id": rangeId,
          "range": selectedObj['range'] ?? ''
        });
      });
      fromDate.clear();
      toDate.clear();

      return true;
    } else {
      _ref.read(quickRangeVal.notifier).state = "1";
      return false;
    }
  }

  void removeQuickRangeItemFromFilteredList() {
    _ref.read(selectedFiltersList.notifier).update((state) {
      final newList = List<Map<String, String>>.from(state);
      newList.removeWhere((element) =>
      element.containsKey('range_id') && element.containsKey('range'));
      return newList;
    });

    // also reset the quickRangeVal to null
    _ref.read(quickRangeVal.notifier).state = "1";
  }

  void addDateRangeInList(){
    // update selected filters (DO NOT refresh here)
    _ref.read(selectedFiltersList.notifier).update((state) {
      if(fromDate.text.isNotEmpty && toDate.text.isNotEmpty){
        return _updateFilterList(state, {
          "date_range": "1",
          "from": fromDate.text.toString(),
          "to": toDate.text.toString()
        });
      }else {
        return state;
      }

    });
    DebugConfig.debugLog('SADasdFromAnd To :: ${_ref.read(selectedFiltersList.notifier).state}');
  }

  // void addToDateInList(){
  //   // update selected filters (DO NOT refresh here)
  //   _ref.read(selectedFiltersList.notifier).update((state) {
  //     return _updateFilterList(state, {
  //       "to_id": "1",
  //       "to": toDate.text.toString()
  //     });
  //   });
  //
  //   DebugConfig.debugLog('SADasdTooo :: ${_ref.read(selectedFiltersList.notifier).state}');
  // }

  bool paymentModeOnChange(Map<String, String>? selectedObj) {
    if (selectedObj != null) {
      final payId = selectedObj['pay_id'] ?? '';
      _ref.read(selectedPaymentMode.notifier).state = payId;

      // update selected filters (DO NOT refresh here)
      _ref.read(selectedFiltersList.notifier).update((state) {
        return _updateFilterList(state, {
          "pay_id": payId,
          "pay_mode": selectedObj['pay_mode'] ?? ''
        });
      });

      return true;
    } else {
      _ref.read(selectedPaymentMode.notifier).state = "1";
      return false;
    }
  }

  bool destinationOnChange(Map<String, String>? selectedObj) {
    if (selectedObj != null) {
      final payId = selectedObj['des_id'] ?? '';
      _ref.read(slctdDestination.notifier).state = payId;

      // update selected filters (DO NOT refresh here)
      _ref.read(selectedFiltersList.notifier).update((state) {
        return _updateFilterList(state, {
          "des_id": payId,
          "des": selectedObj['des'] ?? ''
        });
      });

      return true;
    } else {
      _ref.read(slctdDestination.notifier).state = "1";
      return false;
    }
  }

  bool courierOnChange(Map<String, String>? selectedObj) {
    if (selectedObj != null) {
      final payId = selectedObj['courier_id'] ?? '';
      _ref.read(slctdCourier.notifier).state = payId;

      // update selected filters (DO NOT refresh here)
      _ref.read(selectedFiltersList.notifier).update((state) {
        return _updateFilterList(state, {
          "courier_id": payId,
          "courier": selectedObj['courier'] ?? ''
        });
      });

      return true;
    } else {
      _ref.read(slctdCourier.notifier).state = "1";
      return false;
    }
  }

  // List<Map<String, String>> _updateFilterList(
  //     List<Map<String, String>> list, Map<String, String> selectedObj) {
  //   final newList = List<Map<String, String>>.from(list);
  //
  //   String? keyField;
  //   if (selectedObj.containsKey('range_id')) keyField = 'range_id';
  //   if (selectedObj.containsKey('pay_id')) keyField = 'pay_id';
  //   if (selectedObj.containsKey('des_id')) keyField = 'des_id';
  //   if (selectedObj.containsKey('courier_id')) keyField = 'courier_id';
  //   if (selectedObj.containsKey('from_id')) keyField = 'from_id';   // 👈 added
  //   if (selectedObj.containsKey('to_id')) keyField = 'to_id';
  //
  //   if (keyField != null) {
  //     final index = newList.indexWhere((map) => map.containsKey(keyField));
  //     if (index != -1) {
  //       newList[index] = Map<String, String>.from(selectedObj);
  //     } else {
  //       newList.add(Map<String, String>.from(selectedObj));
  //     }
  //   }
  //
  //   return newList; // always return a fresh list
  // }

  List<Map<String, String>> _updateFilterList(
      List<Map<String, String>> list, Map<String, String> selectedObj) {
    final newList = List<Map<String, String>>.from(list);

    // take the first key of the object (like from_id, to_id, range_id, etc.)
    final keyField = selectedObj.keys.first;

    final index = newList.indexWhere((map) => map.containsKey(keyField));
    if (index != -1) {
      newList[index] = Map<String, String>.from(selectedObj);
    } else {
      newList.add(Map<String, String>.from(selectedObj));
    }

    return newList;
  }


  void removeFromFilter(Map<String, String> obj) {
    DebugConfig.debugLog("Removed from selectedFiltersList: $obj");
    _ref.read(selectedFiltersList.notifier).update((state) {
      // create a copy
      final newList = List<Map<String, String>>.from(state);

      // find index of matching entry
      final index = newList.indexWhere((element) =>
          mapEquals(element, obj)); // strict equality

      if (index != -1) {
        newList.removeAt(index);
      }

      return newList; // <-- return a NEW list reference
    });

    if (obj.containsKey('range_id')) {
      _ref.read(quickRangeVal.notifier).state = "1";
    }else if(obj.containsKey('pay_id')){
      _ref.read(selectedPaymentMode.notifier).state = "1";
    }else if(obj.containsKey('des_id')){
      _ref.read(slctdDestination.notifier).state = "1";
    }else if(obj.containsKey('courier_id')){
      _ref.read(slctdCourier.notifier).state = "1";
    }else if(obj.containsKey('date_range')){
      fromDate.clear();
      toDate.clear();
    }
  }

  Future<ShipmentDataModel?> clearAllFilter(selectedIndex, WidgetRef ref, ShipmentViewModel shipmentVm) async{
    // isLoadingInFilter = true;
    // _ref.refresh(loadingProvider.notifier).state = true;
    // await Future.delayed(Duration(milliseconds: 100));

    // await Future.delayed(Duration(seconds: 1));
    // _ref.refresh(loadingProvider.notifier).state = false;
    // debounceApplyFilter(() {
    Future.delayed(Duration(milliseconds: 500),() async {
      final res = await getShipmentDetailsData(ref, shipmentVm);
      if(res != null){
        clearDetails();
        return res;
      }
      return res;
    });
    return null;

    // });
  }

  void clearDetails(){
    fromDate.clear();
    toDate.clear();
    _ref.refresh(quickRangeVal.notifier).state = '1';
    _ref.refresh(selectedPaymentMode.notifier).state = '1';
    _ref.refresh(slctdCourier.notifier).state = '1';
    _ref.refresh(slctdDestination.notifier).state = '1';
    _ref.refresh(selectedFiltersList.notifier).state.clear();
    _ref.refresh(appliedFilterList.notifier).state.clear();
  }

  String getFilterValue(List<Map<String, String>> filters, String key, String nameKey) {
    final f = filters.firstWhere((v) => v.containsKey(key), orElse: () => {});
    if (f.isNotEmpty && f[key] != "1");else if(f.isNotEmpty && f[nameKey] == "Today"){return "today";} return f[nameKey].toString().replaceAll(" ", '').toLowerCase();
    return "";
  }

  Future<ShipmentDataModel?> getShipmentDetailsData(WidgetRef ref ,ShipmentViewModel shipmentVm) async{
    // clearDetails();

    final userAuth = UserAuthentication();
    final appliedList = ref.read(selectedFiltersList.notifier).state;
    final quickRange = ref.read(quickRangeVal.notifier).state;
    DebugConfig.debugLog('Applied Filter list :: $appliedList');
    String sltdPaymentMode = getFilterValue(appliedList, "pay_id", "pay_mode");
    String sltdDest = getFilterValue(appliedList, "des_id", "des");
    String sltdCourier = getFilterValue(appliedList, "courier_id", "courier");
    String sltdQuickRange = getFilterValue(appliedList, "range_id", "range");

    DebugConfig.debugLog('Selelerd pay : $sltdPaymentMode');
    DebugConfig.debugLog('Selelerd des : $sltdDest');
    DebugConfig.debugLog('Selelerd courier : $sltdCourier');
    DebugConfig.debugLog('Selelerd quick range : $sltdQuickRange');

    final body = {
      "courier_type": "ecom",
      "quickRange": quickRange != null ? sltdQuickRange != "null" ? sltdQuickRange : "today" : "",
      "payment_mode": sltdPaymentMode != "null" ? sltdPaymentMode : "",
      "destination_zone": sltdDest != "null" ? sltdDest : "",
      "tagged_api": ""
    };

    DebugConfig.debugLog('quickRange ki valuee  :: $quickRange \n fasd :: $sltdQuickRange');

    // ✅ Add extra keys if quickRange is null
    if ((quickRange == "1" || sltdQuickRange == "today") && fromDate.text.isNotEmpty && toDate.text.isNotEmpty) {
      String from = CommonMethods.formatDateForRequest(date: fromDate.text.toString());
      String to = CommonMethods.formatDateForRequest(date: toDate.text.toString());
      body['quickRange'] = "";
      body["fromDate"] = from;
      body["toDate"] = to;
    }

    DebugConfig.debugLog('UserAuth idd :: ${userAuth.id}');
    // final clientDet = {
    //   "client_id": userAuth.id != null ? userAuth.id.toString() : '',
    //   "level": userAuth.level != null ? userAuth.level.toString() : '',
    // };
    final clientDet = userAuth.getClientDetails(userAuth.id != null ? userAuth.id.toString() : '');
    final applied = await shipmentVm.fetchShipmentData(body: body, loaderRef: ref, clientDetails: clientDet);
    if(applied != null){
      syncAppliedFilters();
      return applied;
    }else{
      return null;
    }
  }

  void syncAppliedFilters() {
    _ref.read(appliedFilterList.notifier).state =
    List<Map<String, String>>.from(_ref.read(selectedFiltersList.notifier).state);
    Future.delayed(Duration(milliseconds: 200),()=>_ref.read(selectedFiltersList.notifier).state.clear());
  }


  // void syncAppliedFilters() {
  //   final selected = _ref.read(selectedFiltersList.notifier).state;
  //   final applied = List<Map<String, String>>.from(_ref.read(appliedFilterList.notifier).state);
  //
  //   for (final sel in selected) {
  //     // check if an object with the same key already exists
  //     final key = sel.keys.first; // e.g. "date_range", "pay_id", etc.
  //     final index = applied.indexWhere((map) => map.containsKey(key));
  //
  //     if (index != -1) {
  //       applied[index] = sel; // overwrite
  //     } else {
  //       applied.add(sel); // insert new
  //     }
  //   }
  //
  //   _ref.read(appliedFilterList.notifier).state = applied;
  // }



  void assignAllSelectedFilters() {
    final applied = _ref.read(appliedFilterList);

    if(applied.isNotEmpty){
      // reset all to defaults
      fromDate.clear();
      toDate.clear();
      _ref.read(quickRangeVal.notifier).state = "1";
      _ref.read(selectedPaymentMode.notifier).state = "1";
      _ref.read(slctdCourier.notifier).state = "1";
      _ref.read(slctdDestination.notifier).state = "1";
      _ref.read(selectedFiltersList.notifier).state =
      List<Map<String, String>>.from(_ref.read(appliedFilterList.notifier).state);

      // reassign from applied filters
      for (final f in applied) {
        if (f.containsKey("date_range")) {
          fromDate.text = f["from"] ?? "";
          toDate.text   = f["to"] ?? "";
        }
        if (f.containsKey("range_id")) {
          _ref.read(quickRangeVal.notifier).state = f["range_id"] ?? "1";
        }
        if (f.containsKey("pay_id")) {
          _ref.read(selectedPaymentMode.notifier).state = f["pay_id"] ?? "1";
        }
        if (f.containsKey("courier_id")) {
          _ref.read(slctdCourier.notifier).state = f["courier_id"] ?? "1";
        }
        if (f.containsKey("des_id")) {
          _ref.read(slctdDestination.notifier).state = f["des_id"] ?? "1";
        }
      }
    }

    DebugConfig.debugLog("Re-assigned filters :: $applied");
  }




}