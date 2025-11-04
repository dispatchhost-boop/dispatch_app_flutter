import 'package:dispatch/models/auth_model/sign_in_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_client/web_api_provider/web_api_provider.dart';
import '../../models/auth_model/check_kyc_status_model.dart';

var signInRepoData = Provider((ref) => SignInScreenRepo(ref.read(webApiProvider)));

class SignInScreenRepo{
  late final WebApiProvider _ref;
  SignInScreenRepo(this._ref);

  Future<SignInModel?> onSignInAccount({required WidgetRef loaderRef, required Map<String, String> body}) async {

    return await _ref.signInAccount(loaderRef: loaderRef, body: body);

  }

  // Future<CheckKycStatusModel?> getKycStatus({required WidgetRef loaderRef}) async {
  //
  //   return await _ref.getKycStatus(loaderRef: loaderRef);
  //
  // }

}