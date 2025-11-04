import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:dispatch/services/login_credentials/login_credentials.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:dispatch/view_model/app_drawer_vm/drawer_vm.dart';
import 'package:dispatch/view_model/dashboard_vm/dashboard_screen_vm.dart';
import 'package:dispatch/view_model/dashboard_vm/overview_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../const/app_colors.dart';
import '../../const/common_widget.dart';
import '../../const/loader/loader_controller.dart';
import '../../models/dashboard_model/client_list_model.dart';

class AppDrawer extends ConsumerWidget {
  final DashboardScreenViewModel dashboardVm;
  final OverviewViewModel overviewVm;
  const AppDrawer({super.key, required this.dashboardVm, required this.overviewVm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppDrawerViewModel _vm = AppDrawerViewModel(ref);
    final userAuth = ref.watch(_vm.userAuthProvider);
    final slctdClient = ref.watch(dashboardVm.sltdClientDetails);
    final clientsList = ref.watch(dashboardVm.clientsListData);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.mainClr),
            margin: const EdgeInsets.only(bottom: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 35,
                  // backgroundImage: Image.network("https://dispatchsolutions.in/assets/images/logos/dtdc.png",),
                  backgroundColor: Colors.white,
                  child: Center(child: MyTextStyles.getRegularText(text: userAuth.name?[0].toUpperCase() ?? '', size: 35),),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextStyles.getSemiBoldText(text: userAuth.name ?? '', clr: AppColors.white),
                      MyTextStyles.getRegularText(text: userAuth.email ?? '', clr: Colors.white70),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: const Text('Home'),
          //   onTap: () {
          //     Navigator.pop(context); // close drawer
          //     Get.offAllNamed("/home"); // or Get.to(() => HomeScreen());
          //   },
          // ),

          if(clientsList != null)
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100
              ),
              child: Center(child: Column(
                children: [
                  CommonWidget.buildDropDown<String>(
                    maxWidth: 250,
                    maxHeight: 400,
                    label: AppStrings.segmentType, items: ['B2C Express', 'eCommerce'], onChanged: (v) async {


                  }, hint: AppStrings.select, fontSize: 15, validator: true, value: null,
                    displayItem: (v) {
                      return v;
                    },),
                  SizedBox(height: 8,),
                  CommonWidget.buildDropDown<Clients>(
                    maxWidth: 250,
                    maxHeight: 400,
                    label: AppStrings.switchClient, items: clientsList.clients ?? [], onChanged: (v) async {

                    if (v != null) {
                      // DebugConfig.debugLog('Before selected Client :: ${ref.read(dashboardVm.sltdClientDetails)}');
                      try{
                        ref.refresh(loadingProvider.notifier).state = true;
                        await Future.delayed(Duration(seconds: 1));
                        dashboardVm.clientOnChange(v).then((_) async {
                          // final updatedClient = ref.read(dashboardVm.sltdClientDetails); // 👈 read latest value
                          // DebugConfig.debugLog('After client change :: $updatedClient');
                          final newSlctdClient = ref.read(dashboardVm.sltdClientDetails);
                          await _vm.clientChangeApi(loaderRef: ref, clientDetails: newSlctdClient ?? {}).then((v) async {
                            if(v != null){
                              final tokenReplaced =  await UserAuthentication().replaceToken(v.token ?? '');
                              if(tokenReplaced){
                                await overviewVm.onFetchOverviewData(
                                    loaderRef: ref,
                                    loader: false
                                ).then((res){
                                  if(res != null){
                                    ref.refresh(dashboardVm.selectedTab.notifier).state = "Overview";
                                    Get.back();
                                  }
                                });
                              }
                            }
                          });
                        });
                      }finally{
                        ref.refresh(loadingProvider.notifier).state = false;
                      }
                    }

                  }, hint: AppStrings.select, fontSize: 15, validator: true, value: slctdClient == null
                      ? null : clientsList.clients?.firstWhere(
                        (element) => element.id.toString() == slctdClient['selectedClientId'],
                  ),
                    displayItem: (v) {
                      return v.companyName ?? '';
                    },),
                  SizedBox(height: 5,),
                ],
              )),
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () async {

              var a = userAuth.token ?? '';
              DebugConfig.debugLog('hahahahahah :: \n $a');
              // // Navigator.pop(context); // close drawer
              // // Get.toNamed("/settings"); // or Get.to(() => SettingsScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: MyTextStyles.getRegularText(text: AppStrings.logout),
            onTap: () {
              Navigator.pop(context);
              LoginCredentials().userLogout();
              Get.offAllNamed("/login");
            },
          ),
        ],
      ),
    );
  }
}
