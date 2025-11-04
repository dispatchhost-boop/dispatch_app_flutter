
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_client/web_api_provider/web_api_provider.dart';
import '../../models/auth_model/sign_up_model.dart';

var signUpRepoData = Provider((ref) => SignUpScreenRepo(ref.read(webApiProvider)));

class SignUpScreenRepo {
  late final WebApiProvider _ref;
  SignUpScreenRepo(this._ref);

Future<SignUpModel?> fetchSignUpAccount({required WidgetRef loaderRef, required Map<String, String> body})async{
  return await _ref.signUpAccount(loaderRef: loaderRef, body: body);
}

}