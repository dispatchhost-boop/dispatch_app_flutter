import 'package:dispatch/const/common_methods.dart';
import 'package:dispatch/models/auth_model/sign_in_model.dart';
import 'package:dispatch/services/login_credentials/login_credentials.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:dispatch/views/dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../models/auth_model/check_kyc_status_model.dart';
import '../../repositories/auth_repo/sign_in_repo.dart';
import '../../views/digio_kyc/digio_kyc_home.dart';

class LoginViewModel{
  late SignInScreenRepo _repo;
  late final WidgetRef _ref;
  LoginViewModel(this._ref){
    _repo = _ref.read(signInRepoData);
  }

  final checkApproved = StateProvider<bool>((ref)=> false);
  // final checkRequired = StateProvider<bool>((ref)=> false);

  Future<SignInModel?> onSignInAccount({required WidgetRef loaderRef, required Map<String, String> body}) async {

    SignInModel? res = await _repo.onSignInAccount(loaderRef: loaderRef, body: body);
    if(res != null){
      if(res.token != null && res.token!.isNotEmpty){
        CommonMethods.showSnackBar(title: 'Success', message: res.message ?? '');
        LoginCredentials().saveToken(res.token ?? '');
        await UserAuthentication().loadTokenFromStorage();
        // DebugConfig.debugLog('Logintoken : ${await LoginCredentials().getToken()}');
        if(res.isKycVerified == 1){
          Get.off(()=> DashboardScreen());
          // await getKycStatus(loaderRef: loaderRef);
          // Get.off(()=> KycDashboard());
          // Get.to(()=> KycDocumentsScreen());
        }else{
          Get.off(()=> DigioKycHome());
        }
      }

    }
      return res;
  }

  // Future<CheckKycStatusModel?> getKycStatus({required WidgetRef loaderRef}) async {
  //
  //   CheckKycStatusModel? res = await _repo.getKycStatus(loaderRef: loaderRef);
  //   if(res != null){
  //     // if(res. != null && res.token!.isNotEmpty){
  //       CommonMethods.showSnackBar(title: 'Success Kyc', message: res.customerIdentifier ?? '');
  //     //   LoginCredentials().saveToken(res.token ?? '');
  //     //   await UserAuthentication().loadTokenFromStorage();
  //     //   // DebugConfig.debugLog('Logintoken : ${await LoginCredentials().getToken()}');
  //     //   if(res.isKycVerified == false){
  //     //
  //     //     // Get.off(()=> KycDashboard());
  //     //     // Get.to(()=> KycDocumentsScreen());
  //     //   // }else{
  //     //   //   Get.off(()=> DashboardScreen());
  //     //   // }
  //     // }
  //
  //     if(res.id != null && res.id!.isNotEmpty && res.referenceId != null && res.referenceId!.isNotEmpty && res.referenceId != null && res.referenceId!.isNotEmpty){
  //       // Get.to(()=> DigioKycDashboard());
  //       Get.to(()=> DigioKycHome(docDetails: {"documentId": res.id ?? '', "token": res.referenceId ?? '', "userIdentifier": res.referenceId ?? '', },));
  //     }
  //
  //   }
  //   return res;
  // }

}