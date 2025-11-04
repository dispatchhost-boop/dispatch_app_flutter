import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../models/dashboard_model/client_list_model.dart';
import '../../models/dashboard_model/overview_model.dart';
import '../../repositories/dashboard_repo/overview_repo.dart';

class OverviewViewModel{
  late final WidgetRef _ref;
  late OverviewRepo _repo;
  OverviewViewModel(this._ref) {
    _repo = _ref.read(overviewRepo);
  }

    final selectedFilterProvider = StateProvider<String>((ref) => "All");
    final selectedDropDownProvider = StateProvider<String>((ref) => "Shipped");
    final overviewApiData = StateProvider<DashboardOverviewModel?>((ref)=> null);

    Future<DashboardOverviewModel?> onFetchOverviewData({required WidgetRef loaderRef, required bool loader}) async {
    DashboardOverviewModel? res = await _repo.fetchOverviewData(loaderRef: loaderRef, loader: loader);
    _ref.refresh(overviewApiData.notifier).state = res;
    return res;
  }
  }
