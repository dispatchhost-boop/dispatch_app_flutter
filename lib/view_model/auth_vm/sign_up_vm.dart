
import 'package:dispatch/repositories/auth_repo/sign_up_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../const/response_dialog.dart';
import '../../models/auth_model/sign_up_model.dart';

class SignUpViewModel{
  late SignUpScreenRepo _repo;
  late final WidgetRef _ref;
  SignUpViewModel(this._ref){
    _repo = _ref.read(signUpRepoData);
  }

  final selectedSegment = StateProvider<String?>((ref) => null);
  final selectedCategory = StateProvider<String?>((ref) => null);
  final selectedVol = StateProvider<Map<String, String>?>((ref) => null);
  final selectedShipment = StateProvider<Map<String, String>?>((ref) => null);
  final agreeCheck = StateProvider<bool>((ref) => false);
  final agreeCheckRequired = StateProvider<bool>((ref) => false);
  final List<String> segmentList = ['Express', 'Ecom'];
  final List<String> categoryList = ['Retailer', 'E-commerce', 'Manufacturer', 'Distributor', 'Service Provider', 'Other'];

  final List<Map<String, String>> volumeList = [
    {'id': '1', 'volume': 'Basic (0.00 - 25000.00 /Month)'},
    {'id': '3', 'volume': 'LitePro (50001.00 - 100000.00 /Month)'},
    {'id': '4', 'volume': 'Premium (100001.00 - 250000.00 /Month)'},
    {'id': '5', 'volume': 'Advance (250001.00 - 500000.00 /Month)'},
    {'id': '6', 'volume': 'AdvancedPro (500001.00 -  /Month)'},
    {'id': '7', 'volume': 'Enterprise ( -  /Month)'},
  ];
  final List<Map<String, String>> shipmentsList = [
    {'id': '1', 'ship': '0 - 500 Shipment'},
    {'id': '2', 'ship': '500 - 1000 Shipment'},
    {'id': '3', 'ship': '1000 - 1500 Shipment'},
    {'id': '4', 'ship': '1500 - 2000 Shipment'},
    {'id': '5', 'ship': '2000 - 2500 Shipment'},
    {'id': '6', 'ship': '2500 - 3000 Shipment'},
    {'id': '7', 'ship': '3000 - 3500 Shipment'},
    {'id': '8', 'ship': '3500 - 4000 Shipment'},
    {'id': '9', 'ship': '4000 Above'},
  ];

  void segmentOnChange(String val) async {
    _ref.refresh(selectedSegment.notifier).state = val;
    _ref.refresh(selectedVol.notifier).state = null;
    _ref.refresh(selectedShipment.notifier).state = null;
    // print('object1 : ${_ref.read(selectedSegment.notifier).state}');
  }

  void categoryOnChange(String val) async {
    _ref.refresh(selectedCategory.notifier).state = val;
    // print('object11 : ${_ref.read(selectedBusinessCategory.notifier).state}');
  }

  Future<SignUpModel?> fetchCreateAccount({required WidgetRef loaderRef, required Map<String, String> body}) async {

    SignUpModel? res = await _repo.fetchSignUpAccount(loaderRef: loaderRef, body: body);

    if(res != null){
      final String? status = res.status is String ? res.status as String : null;
      // ✅ Handle based on status
      // if (status == '1' || status == '2') {
        Get.dialog(
          ResponseDialog(
            title: AppStrings.response,
            msg: res.message ?? '',
            buttonText: AppStrings.ok,
            popTimes: 1,
            dlgClr: AppColors.mainClr,
            onPressed1: () {
              Get.back(); // Cancel button action
            },
          ),
          barrierDismissible: false,
        );

      // }else{
      //   return res;
      // }
      return res;
    }
    return null;
  }


}