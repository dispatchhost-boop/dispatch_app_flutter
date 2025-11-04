
import 'package:dispatch/api_client/web_api_provider/web_api_provider.dart';
import 'package:dispatch/models/dashboard_model/client_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/kyc_model/client_kyc_data_model.dart';

var dashboardRepo = Provider((ref)=> DashboardRepo(ref.read(webApiProvider)));

class DashboardRepo{
  late final WebApiProvider _ref;
  DashboardRepo(this._ref);

  Future<ClientsListModel?> fetchAllClientsList({required WidgetRef loaderRef}){
    return _ref.getAllClientsList(loaderRef: loaderRef);
  }

  Future<ClientKycDataModel?> fetchClientKycData({required WidgetRef loaderRef})async{
    final res = await _ref.getClientKycData(loaderRef: loaderRef);
    return res;
  }

}

