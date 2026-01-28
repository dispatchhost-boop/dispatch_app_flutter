import 'package:dispatch/models/client_change_model.dart';
import 'package:dispatch/repositories/app_drawer_repo/drawer_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/app_drawer_repo/drawer_repo.dart';
import '../../services/login_credentials/user_authentications.dart';

class AppDrawerViewModel{
  late final WidgetRef _ref;
  late final AppDrawerRepo _repo;

  AppDrawerViewModel(this._ref){
    _repo = _ref.read(appDrawerRepo);
  }


  final userAuthProvider = Provider<UserAuthentication>((ref) {
    return UserAuthentication();
  });

  Future<ClientChangeModel?> clientChangeApi({required WidgetRef loaderRef, required Map<String, String> clientDetails}){
    return _repo.clientChangeApi(loaderRef: loaderRef, clientDetails: clientDetails);
  }

}