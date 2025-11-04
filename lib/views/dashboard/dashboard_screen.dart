import 'package:dispatch/const/buttons.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:dispatch/view_model/dashboard_vm/filter_vm.dart';
import 'package:dispatch/view_model/dashboard_vm/overview_vm.dart';
import 'package:dispatch/views/dashboard/rto_tabview.dart';
import 'package:dispatch/views/dashboard/shipment_tabview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../const/loader/loader_controller.dart';
import '../../models/dashboard_model/client_list_model.dart';
import '../../view_model/dashboard_vm/dashboard_screen_vm.dart';
import '../../view_model/dashboard_vm/shipment_vm.dart';
import '../app_drawer/drawer_view.dart';
import 'overview_tabview.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late DashboardScreenViewModel _vm;
  late OverviewViewModel _overviewVm;
  late ShipmentViewModel _shipmentVm;
  late DashBoardFilterViewModel _filterVm;
  // final List<String> filters = [
  //   "Overview",
  //   "Shipments",
  //   "RTO",
  //   "NDR",
  //   "COD"
  // ];
  // String selectedFilter = '';
  // String selecteddropDown = 'Shipped';

  @override
  void initState() {
  super.initState();
  // selectedFilter = "Overview";
  _vm = DashboardScreenViewModel(ref);
  _overviewVm = OverviewViewModel(ref);
  _shipmentVm = ShipmentViewModel(ref);
  _filterVm = DashBoardFilterViewModel(ref);
  WidgetsBinding.instance.addPostFrameCallback((_){
  _vm.onFetchAllClientsList(loaderRef: ref);
  });
  }

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final media = MediaQuery.of(context);
    final screenHeight =  kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    bool isBigSize = screenWidth >= 550;
    return Consumer(
        builder: (context, loader, _) {
      final isLoading = loader.watch(loadingProvider);
      return PopScope(
          canPop: isLoading ? false : true,
          child: Center(
          child: SizedBox(
            // padding: EdgeInsets.only(left: 20, right: 20, top: 0),
            // width: screenWidth * 0.9,
          child: Scaffold(
          appBar: AppBar(
            title: MyTextStyles.getRegularText(text: 'Dashboard', size: 18 * textScale),
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          drawer: AppDrawer(dashboardVm: _vm, overviewVm: _overviewVm,),
          body: Column(
                children: [
                _buildTabsList(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale,),
                SizedBox(height: screenHeight * 0.012,),
                Consumer(builder: (key, ref, child){
                  final selectedTab = ref.watch(_vm.selectedTab.notifier).state;
                  // final sltdClient = ref.read(_vm.sltdClientDetails.notifier).state;
                  // if(sltdClient != null){
                    return Expanded(child: SingleChildScrollView(child: getTabBarViews(selectedTab,)));
                    // return Expanded(child: SingleChildScrollView(child: getTabBarViews(selectedTab, sltdClient)));
                  // }else{
                  //   return Expanded(child: Center(child: MyTextStyles.getRegularText(text: AppStrings.noDataAvailable),));
                  //   // return Expanded(child: SingleChildScrollView(child: getTabBarViews(selectedTab, sltdClient ?? {"client_id": "", "level": ""})));
                  // }
                  
                })
                ],
                )
              )))
            );
            });
  }

  Widget _buildTabsList({required double screenWidth, required double screenHeight, required double textScale}){
    return Consumer(builder: (key, ref, child){
      final selectedFilter = ref.watch(_vm.selectedTab.notifier).state;
      return Container(
        height: screenHeight * 0.05,
        padding: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03, top: 0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _vm.tabsList.length,
          separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.018),
          itemBuilder: (context, index) {
            final filter = _vm.tabsList[index];
            final isSelected = filter == selectedFilter;
            return ChoiceChip(
              padding: EdgeInsets.only(left: screenWidth * 0.008, right: screenWidth * 0.008, top: 4, bottom: 4),
              label: Text(filter),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.mainClr,
              labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: textScale * 14
              ),
              onSelected: (val) {
                // setState(() => selectedFilter = filter);
                ref.refresh(_vm.selectedTab.notifier).state = filter;
              },
            );
          },
        ),
      );
    });
  }
  
  Widget getTabBarViews(String screen){
    switch(screen){
      case 'Overview':
        return OverviewTabview(vm: _overviewVm);
      case 'Shipments':
        return ShipmentTabview(filterVm: _filterVm, shipmentVm: _shipmentVm,);
      case 'RTO':
        return RtoTabview(filterVm: _filterVm);
      default: 
        return Text('data');
    }
  }

}
