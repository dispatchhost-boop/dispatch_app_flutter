import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/view_model/kyc_vm/kyc_dashbord_vm.dart';
import 'package:dispatch/views/kyc_form/kyc_doc.dart';
import 'package:dispatch/views/kyc_form/profile_details_view.dart';
import 'package:dispatch/views/kyc_form/subscription_plan_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const/app_colors.dart';
import '../../const/common_methods.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/loader/loader_screen.dart';
import '../../view_model/kyc_vm/kyc_doc_vm.dart';
import '../../view_model/kyc_vm/profile_details_vm.dart';

//   class KycDashboard extends ConsumerStatefulWidget {
//     const KycDashboard({super.key});
//
//     @override
//     ConsumerState<KycDashboard> createState() => _KycDashboardState();
//   }
//
// class _KycDashboardState extends ConsumerState<KycDashboard> with SingleTickerProviderStateMixin {
//   late ProfileDetailsViewModel _profileVm;
//   late KycDocumentsViewModel _kycDocVm;
//   late KycDashboardViewModel _vm;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _vm = KycDashboardViewModel(ref);
//     _profileVm = ProfileDetailsViewModel(ref);
//     _kycDocVm = KycDocumentsViewModel(ref);
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(loadingProvider);
//     final onThird = _tabController.index == 2;
//     final screenWidth = kIsWeb ? 400.0 : MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: () async => !isLoading,
//       child: Stack(
//         children: [
//           Scaffold(
//             appBar: AppBar(
//               title: const Text("KYC Dashboard"),
//               automaticallyImplyLeading: false,
//               centerTitle: true,
//               bottom: PreferredSize(
//                   preferredSize: const Size.fromHeight(kToolbarHeight),
//                   child: TabBar(
//                 controller: _tabController,
//                 indicatorColor: AppColors.mainClr,
//                 labelColor: AppColors.mainClr,
//                 unselectedLabelColor: Colors.grey,
//                 tabs: [
//                   Tab(
//                     icon: const Icon(Icons.person),
//                     child: Text(
//                       "Profile",
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       maxLines: 2,
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.038,
//                       ),
//                     ),
//                   ),
//                   Tab(
//                     icon: const Icon(Icons.file_copy),
//                     child: Text(
//                       "Documents",
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       maxLines: 2,
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.038,
//                       ),
//                     ),
//                   ),
//                   Tab(
//                     icon: const Icon(Icons.verified),
//                     child: Text(
//                       AppStrings.subscriptionPlan,
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       maxLines: 2,
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.038,
//                       ),
//                     ),
//                   ),
//                 ],
//                 onTap: (index) {
//                   final profileDetails = ref.read(_vm.profileDetails.notifier).state;
//                   final hasProfile = profileDetails.isNotEmpty;
//
//                   if (onThird) {
//                     switch (index) {
//                       case 0:
//                         if (!hasProfile) {
//                           _tabController.index = 0;
//                         } else {
//                           _tabController.index = _tabController.previousIndex;
//                         }
//                         break;
//                       case 1:
//                         if (hasProfile) {
//                           _tabController.index = 1;
//                         } else {
//                           CommonMethods.showSnackBar(title: "Can't Open", message: "Please complete your profile");
//                           _tabController.index = _tabController.previousIndex;
//                         }
//                         break;
//                       case 2:
//                         _tabController.index = hasProfile ? 1 : 0;
//                         break;
//                     }
//                   } else {
//                     if (index == 2) {
//                       _tabController.index = 2; // Allow moving to Subscription
//                     } else {
//                       if (!hasProfile) {
//                         _tabController.index = 0;
//                       } else {
//                         _tabController.index = 1;
//                       }
//                       if (index == 1 && !hasProfile) {
//                         CommonMethods.showSnackBar(title: "Can't Open", message: "Please complete your profile");
//                       }
//                     }
//                   }
//                 },
//               )),
//             ),
//             body: Center(
//               child: SizedBox(
//                 width: screenWidth > 400 ? 400 : screenWidth * 0.95,
//                 child: TabBarView(
//                   controller: _tabController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     ProfileDetailsView(
//                       tabController: _tabController,
//                       vm: _profileVm,
//                       kycVm: _vm,
//                     ),
//                     KycDocumentsScreen(
//                       tabController: _tabController,
//                       vm: _kycDocVm,
//                       kycVm: _vm,
//                     ),
//                     SubscriptionPlanView(
//                       tabController: _tabController,
//                       profileVm: _profileVm,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (isLoading)
//             const Align(
//               alignment: Alignment.center,
//               child: Loader(),
//             ),
//         ],
//       ),
//     );
//   }
// }
class KycDashboard extends ConsumerStatefulWidget {
  const KycDashboard({super.key});

  @override
  ConsumerState<KycDashboard> createState() => _KycDashboardState();
}

class _KycDashboardState extends ConsumerState<KycDashboard> with SingleTickerProviderStateMixin {
  late ProfileDetailsViewModel _profileVm;
  late KycDocumentsViewModel _kycDocVm;
  late KycDashboardViewModel _vm;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _vm = KycDashboardViewModel(ref);
    _profileVm = ProfileDetailsViewModel(ref);
    _kycDocVm = KycDocumentsViewModel(ref);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    fetchClientData();
  }

  void fetchClientData(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _vm.fetchClientKycDetails(loaderRef: ref);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final onThird = _tabController.index == 2;
    final media = MediaQuery.of(context);
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    final scaledFontSize = 15.0 * textScale;

    return WillPopScope(
      onWillPop: () async => !isLoading,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text("KYC Dashboard"),
              automaticallyImplyLeading: false,
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.mainClr,
                  labelColor: AppColors.mainClr,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.person),
                      child: Text(
                        "Profile",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(fontSize: scaledFontSize),
                      ),
                    ),
                    Tab(
                      icon: const Icon(Icons.file_copy),
                      child: Text(
                        "Documents",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(fontSize: scaledFontSize),
                      ),
                    ),
                    Tab(
                      icon: const Icon(Icons.verified),
                      child: Text(
                        AppStrings.subscriptionPlan,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 3,
                        style: TextStyle(fontSize: scaledFontSize),
                      ),
                    ),
                  ],
                  onTap: (index) {
                    final profileDetails = ref.read(_vm.profileDetails.notifier).state;
                    final hasProfile = profileDetails.isNotEmpty;

                    if (onThird) {
                      switch (index) {
                        case 0:
                          if (!hasProfile) {
                            _tabController.index = 0;
                          } else {
                            _tabController.index = _tabController.previousIndex;
                          }
                          break;
                        case 1:
                          if (hasProfile) {
                            _tabController.index = 1;
                          } else {
                            CommonMethods.showSnackBar(
                                title: "Can't Open", message: "Please complete your profile");
                            _tabController.index = _tabController.previousIndex;
                          }
                          break;
                        case 2:
                          _tabController.index = hasProfile ? 1 : 0;
                          break;
                      }
                    } else {
                      if (index == 2) {
                        _tabController.index = 2; // Allow moving to Subscription
                      } else {
                        if (!hasProfile) {
                          _tabController.index = 0;
                        } else {
                          _tabController.index = 1;
                        }
                        if (index == 1 && !hasProfile) {
                          CommonMethods.showSnackBar(
                              title: "Can't Open", message: "Please complete your profile");
                        }
                      }
                    }
                  },
                ),
              ),
            ),
            body: _onBody(screenWidth: screenWidth),
          ),
          if (isLoading)
            const Align(
              alignment: Alignment.center,
              child: Loader(),
            ),
        ],
      ),
    );
  }

  Widget _onBody({required double screenWidth}){
    final clientDetails = ref.watch(_vm.clientKycData.notifier).state;
    return Center(
      child: SizedBox(
        width: screenWidth > 400 ? 400 : screenWidth * 0.95,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ProfileDetailsView(
              tabController: _tabController,
              vm: _profileVm,
              kycVm: _vm,
            ),
            KycDocumentsScreen(
              tabController: _tabController,
              vm: _kycDocVm,
              kycVm: _vm,
              profileVm: _profileVm,
              clientDetails: {
                "name": clientDetails?.userData?.firstName ?? '',
                "email": clientDetails?.userData?.email ?? '',
                "phone": clientDetails?.userData?.phoneNo ?? ''
              },
            ),
            SubscriptionPlanView(
              tabController: _tabController,
              profileVm: _profileVm,
            ),
          ],
        ),
      ),
    );
  }
}
