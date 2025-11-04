import 'package:dispatch/models/auth_model/sign_in_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_client/web_api_provider/web_api_provider.dart';
import '../../models/auth_model/check_kyc_status_model.dart';

var digioHomeRepoData = Provider((ref) => DigioHomeRepo(ref.read(webApiProvider)));

class DigioHomeRepo{
  late final WebApiProvider _ref;
  DigioHomeRepo(this._ref);

  Future<CheckKycStatusModel?> getKycStatus({required WidgetRef loaderRef}) async {
    return await _ref.getKycStatus(loaderRef: loaderRef);
  }

}