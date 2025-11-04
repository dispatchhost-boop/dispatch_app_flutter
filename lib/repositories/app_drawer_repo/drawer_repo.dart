
import 'package:dispatch/api_client/web_api_provider/web_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/client_change_model.dart';

var appDrawerRepo = Provider((ref)=> AppDrawerRepo(ref.read(webApiProvider)));

class AppDrawerRepo{
  late final WebApiProvider _ref;
  AppDrawerRepo(this._ref);

  Future<ClientChangeModel?> clientChangeApi({required WidgetRef loaderRef, required Map<String, String> clientDetails}){
    return _ref.clientChangeApi(loaderRef: loaderRef, clientDetails: clientDetails);
  }

}