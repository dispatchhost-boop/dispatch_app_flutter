import 'package:dispatch/models/kyc_model/client_kyc_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/dashboard_repo/dashboard_repo.dart';

class KycDashboardViewModel{
  late final WidgetRef _ref;
  late final DashboardRepo  _repo;
  KycDashboardViewModel(this._ref){
    _repo = _ref.read(dashboardRepo);
  }

  final profileDetails = StateProvider<Map<String, String>>((ref)=> {});
  final clientKycData = StateProvider<ClientKycDataModel?>((ref)=> null);


  Future<ClientKycDataModel?> fetchClientKycDetails({required WidgetRef loaderRef}) async {
    final r = await _repo.fetchClientKycData(loaderRef: loaderRef);
    _ref.refresh(clientKycData.notifier).state = r;
    return r;
  }



}