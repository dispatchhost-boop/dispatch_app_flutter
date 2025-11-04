import 'package:dispatch/const/common_methods.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/models/auth_model/sign_in_model.dart';
import 'package:dispatch/services/login_credentials/login_credentials.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:dispatch/views/dashboard/dashboard_screen.dart';
import 'package:dispatch/views/kyc_form/kyc_dashboard.dart';
import 'package:dispatch/views/kyc_form/kyc_doc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../repositories/auth_repo/sign_in_repo.dart';

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
        if(res.isKycVerified == false){
          Get.off(()=> KycDashboard());
          // Get.to(()=> KycDocumentsScreen());
        }else{
          Get.off(()=> DashboardScreen());
        }
      }

    }
      return res;
  }

}