import 'package:dispatch/const/common_methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../models/auth_model/check_kyc_status_model.dart';
import '../../repositories/digio_kyc_repo/digio_home_repo.dart';
import '../../views/digio_kyc/digio_kyc_home.dart';

class DigioKycViewModel{
  late DigioHomeRepo _repo;
  late final WidgetRef _ref;
  DigioKycViewModel(this._ref){
    _repo = _ref.read(digioHomeRepoData);
  }

  Future<CheckKycStatusModel?> getKycStatus({required WidgetRef loaderRef}) async {

    CheckKycStatusModel? res = await _repo.getKycStatus(loaderRef: loaderRef);
    // if(res != null){
    //   // if(res. != null && res.token!.isNotEmpty){
    //   CommonMethods.showSnackBar(title: 'Success Kyc', message: res.customerIdentifier ?? '');
    //
    //   //   LoginCredentials().saveToken(res.token ?? '');
    //   //   await UserAuthentication().loadTokenFromStorage();
    //   //   // DebugConfig.debugLog('Logintoken : ${await LoginCredentials().getToken()}');
    //   //   if(res.isKycVerified == false){
    //   //
    //   //     // Get.off(()=> KycDashboard());
    //   //     // Get.to(()=> KycDocumentsScreen());
    //   //   // }else{
    //   //   //   Get.off(()=> DashboardScreen());
    //   //   // }
    //   // }
    //
    //   // if(res.id != null && res.id!.isNotEmpty && res.referenceId != null && res.referenceId!.isNotEmpty && res.referenceId != null && res.referenceId!.isNotEmpty){
    //   //   // Get.to(()=> DigioKycDashboard());
    //   //   // Get.to(()=> DigioKycHome(docDetails: {"documentId": res.id ?? '', "token": res.referenceId ?? '', "userIdentifier": res.referenceId ?? '', },));
    //   // }
    //
    // }
    return res;
  }

}