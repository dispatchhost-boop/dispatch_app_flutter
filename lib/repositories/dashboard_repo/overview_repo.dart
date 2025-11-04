
import 'package:dispatch/api_client/web_api_provider/web_api_provider.dart';
import 'package:dispatch/models/dashboard_model/client_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/dashboard_model/overview_model.dart';

var overviewRepo = Provider((ref)=> OverviewRepo(ref.read(webApiProvider)));

class OverviewRepo{
  late final WebApiProvider _ref;
  OverviewRepo(this._ref);

  Future<DashboardOverviewModel?> fetchOverviewData({required WidgetRef loaderRef, required bool loader}){
    return _ref.getOverviewData(loaderRef: loaderRef, loader: loader);
  }

}