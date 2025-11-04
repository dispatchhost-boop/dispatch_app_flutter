import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/dashboard_model/client_list_model.dart';
import '../../repositories/dashboard_repo/dashboard_repo.dart';

class DashboardScreenViewModel{
  late final WidgetRef _ref;
  late DashboardRepo _repo;
  DashboardScreenViewModel(this._ref) {
    _repo = _ref.read(dashboardRepo);
  }

  final List<String> tabsList = [
    "Overview",
    "Shipments",
    "RTO"
  ];

  final selectedTab = StateProvider<String>((ref)=> 'Overview');
  final clientsListData = StateProvider<ClientsListModel?>((ref)=> null);
  final sltdClientDetails = StateProvider<Map<String, String>?>((ref)=> null);

  Future<ClientsListModel?> onFetchAllClientsList({required WidgetRef loaderRef}) async {
    DebugConfig.debugLog('Only one time fetched');
    ClientsListModel? res = await _repo.fetchAllClientsList(loaderRef: loaderRef);
    _ref.refresh(clientsListData.notifier).state = res;
    if (res != null && res.clients != null  && res.clients!.isNotEmpty) {
      final firstClient = res.clients?.first;

      // ✅ Update clientId provider
      String cId = firstClient?.id != null ? firstClient!.id.toString() : "";
      // String cLevel = firstClient?.level != null ? firstClient!.level.toString() : "";

      // ✅ Update client details provider
      // _ref.read(sltdClientDetails.notifier).state = {
      //   "client_id": cId,
      //   "level": cLevel,
      // };
      _ref.read(sltdClientDetails.notifier).state = UserAuthentication().getClientDetails(cId);
    }
    return res;
  }

  Future<bool> clientOnChange(Clients c) async {
    // _ref.read(sltdClientDetails.notifier).state = {
    //   "client_id": c.id?.toString() ?? "",
    //   "level": c.level?.toString() ?? "",
    // };
    _ref.read(sltdClientDetails.notifier).state = UserAuthentication().getClientDetails(c.id?.toString() ?? "");

    return true;
  }



}