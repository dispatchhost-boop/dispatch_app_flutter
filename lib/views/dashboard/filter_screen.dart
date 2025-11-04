
import 'package:dispatch/const/buttons.dart';
import 'package:dispatch/const/common_widget.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/const/loader/loader_controller.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:dispatch/repositories/dashboard_repo/shipment_repo.dart';
import 'package:dispatch/view_model/dashboard_vm/shipment_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../connectivity/internet_controller.dart';
import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../view_model/dashboard_vm/filter_vm.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final DashBoardFilterViewModel filterVm;
  final ShipmentViewModel? shipmentVm;
  const FilterScreen({super.key, required this.filterVm, this.shipmentVm});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen>{

  int _selectedIndex = 0;
  late DashBoardFilterViewModel _vm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _vm = DashBoardFilterViewModel(ref);
    _vm = widget.filterVm;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final provider = Provider.of<DashboardProvider>(context, listen: false);
      // provider.reloadSelectedFilters();
      _vm.assignAllSelectedFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight =  kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    bool isBigSize = screenWidth >= 550;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12),)
          ),
          child: Padding(padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                _buildHeader(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                _buildActiveFilters(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                Expanded(
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // _buildDateRange(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                            _buildSidebarTabs(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: IndexedStack(
                                  index: _selectedIndex,
                                  children: [
                                    _buildTab1View(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                                    _buildTab2View(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                                    _buildTab3View(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                                    _buildTab4View(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                                    _buildTab5View(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            bottom: screenHeight* 0.05,
                          right: screenWidth * 0.08,
                          // alignment: Alignment.bottomCenter,
                            child: Center(child: AppButtons.buildContainerButton(text: AppStrings.applyFilter, height: 46, width: 150, onTap: () async{
                              // for filter on shipment tab
                              final shipmentVm = widget.shipmentVm;
                              if(shipmentVm != null){
                                final res = await _vm.getShipmentDetailsData(ref, widget.shipmentVm ?? ShipmentViewModel(ref));
                                if(res != null){
                                  Get.back();
                                }
                              }
                            }))),
                      ],
                    )),
              ],
            ),),
        );
      },
    );
  }

  Widget _buildHeader({required double screenWidth, required double screenHeight, required double textScale}) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.clear, color: AppColors.black, size: screenHeight * 0.02,),
            ),
          ),
          SizedBox(width: screenWidth * 0.01),
          Consumer(builder: (key, ref, child){
            final count = ref.watch(_vm.selectedFiltersList).length;
            return MyTextStyles.getSemiBoldText(text: '${AppStrings.filters} ($count)', size: 14 * textScale);
          }),
          const Spacer(),
            TextButton(
              onPressed: () async {
                DebugConfig.debugLog('messagesadasdasd ${ref.read(loadingProvider.notifier).state}');
                if(!ref.read(loadingProvider.notifier).state && ref.read(_vm.selectedFiltersList.notifier).state.isNotEmpty){

                  final res = await _vm.clearAllFilter( _selectedIndex, ref, widget.shipmentVm ?? ShipmentViewModel(ref));
                  if(res != null){
                    Get.back();
                  }
                }
              },
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16)),
              child: MyTextStyles.getRegularText(text: AppStrings.clearAll, size: 14 * textScale, clr: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters({required double screenWidth, required double screenHeight, required double textScale, }) {
    return Consumer(builder: (key, ref, child){
      final selectedFilters = ref.watch(_vm.selectedFiltersList);
      if(selectedFilters.isEmpty) return SizedBox();
      return Container(
        padding: const EdgeInsets.fromLTRB(5, 16, 5, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight *0.006),
            SizedBox(
              // height: screenHeight * 0.05,
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedFilters.length,
                itemBuilder: (context, ind) {
                  final filter = selectedFilters[ind];
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.mainClr, AppColors.mainClr.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyTextStyles.getRegularText(text: getFilterLabel(filter), clr: Colors.white, size: 13 * textScale),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _vm.removeFromFilter(filter),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSidebarTabs({required double screenWidth, required double screenHeight, required double textScale}) {
    return Container(
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        // color: Colors.grey[50],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
        border: Border(right: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTab(AppStrings.dateRange, 0, textScale),
          _buildTab(AppStrings.quickRanges, 1, textScale),
          _buildTab(AppStrings.paymentMode, 2, textScale),
          _buildTab(AppStrings.destinationZone, 3, textScale),
          _buildTab(AppStrings.courier, 4, textScale),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, double textScale) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainClr : AppColors.white,
          borderRadius: BorderRadius.circular(2)
        ),
        child: !isSelected ? MyTextStyles.getRegularText(text: label, clr: Colors.black, size: 14 * textScale)
            : MyTextStyles.getSemiBoldText(text: label, clr: Colors.white, size: 14 * textScale),
      ),
    );
  }

  //Date Range
  Widget _buildTab1View({required double screenWidth, required double screenHeight, required double textScale}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidget.buildTextField(
          controller: _vm.fromDate,
          onTap: () async {
            // await _selectDate(formContext, provider.fromController); // 👈 use formContext
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime.now(),
                barrierDismissible: false,
                builder: (context, child){
                  return Theme(data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.mainClr,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ), child: child!);
                }
            );
            if (picked != null) {
              // controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
              _vm.fromDate.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                  _vm.removeQuickRangeItemFromFilteredList();
                  _vm.addDateRangeInList();
            }

          },
          label: '${AppStrings.from} *',
          hint: 'dd/mm/yyyy',
          maxLines: 1,
          readOnly: true,
          validator: true,
        ),
        SizedBox(height: screenHeight * 0.015,),
        CommonWidget.buildTextField(
          label: '${AppStrings.to} *',
          hint: 'dd/mm/yyyy',
          controller: _vm.toDate,
          onTap: () async {
            if (_vm.fromDate.text.isNotEmpty) {
              // Parse fromDate back to DateTime
              final parts = _vm.fromDate.text.split('/');
              final fromDate = DateTime(
                int.parse(parts[2]), // year
                int.parse(parts[1]), // month
                int.parse(parts[0]), // day
              );

              final picked = await showDatePicker(
                context: context,
                initialDate: fromDate, // 👈 start from "fromDate"
                firstDate: fromDate, // 👈 restrict before fromDate
                lastDate: DateTime.now(),
                  barrierDismissible: false,
                builder: (context, child){
                  return Theme(data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.mainClr,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ), child: child!);
                }
              );
              if (picked != null) {
                _vm.toDate.text =
                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                _vm.removeQuickRangeItemFromFilteredList();
                _vm.addDateRangeInList();
              }
            }
          },
          maxLines: 1,
          readOnly: true,
          validator: true,
        ),
      ],
    );
  }

  //Quick Ranges
  Widget _buildTab2View({required double screenWidth, required double screenHeight, required double textScale}) {
    List<Map<String,String>> lst = [{'range_id' : '1','range': 'Today'},{'range_id' : '2','range': 'Yesterday'},
      {'range_id' : '3','range': 'Last 7 days'},{'range_id' : '4','range': 'Last 30 Days'},
      {'range_id' : '5','range': 'This Month'},{'range_id' : '6','range': 'Last Month'}];
    return Consumer(builder: (key, ref, child){
      final selectedVal = ref.watch(_vm.quickRangeVal);
      DebugConfig.debugLog("filters in UI => $selectedVal");
      return ListView.builder(
          shrinkWrap: true,
          itemCount: lst.length,
          itemBuilder: (context, i){
            final current = lst[i];
            final keyId = current["range_id"] ?? "";
            final isSelected = selectedVal == keyId;

            return Row(
              children: [
                Checkbox(
                  activeColor: AppColors.mainClr,
                  value: isSelected,
                  onChanged: (bool? checked) {
                    if(checked == true){
                      _vm.quickRangeChange(lst[i]);
                    }

                  },
                ),
                Expanded(child: Text(lst[i]['range'] ?? ''))
              ],
            );
          });
    });
  }

  //Payment Mode
  Widget _buildTab3View({required double screenWidth, required double screenHeight, required double textScale}){
    return Consumer(
        builder: (context, provider, child) {
          final payentLst = ref.watch(_vm.paymentModeList);
          final slctdPayment = ref.watch(_vm.selectedPaymentMode);
          if(payentLst.isEmpty){
            return Center(child: Text(AppStrings.noDataAvailable),);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: ListView.builder(
                shrinkWrap: true,
                itemCount: payentLst.length,
                itemBuilder: (context, i) {
                  final current = payentLst[i];
                  final payId = current["pay_id"] ?? "";
                  final isSelected = slctdPayment == payId;

                  return Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.mainClr,
                        value: isSelected,
                        onChanged: (bool? checked) {
                          if(checked == true) {
                            _vm.paymentModeOnChange(payentLst[i]);
                          }
                        },
                      ),
                      Expanded(child: Text(current['pay_mode'] ?? '')),
                    ],
                  );
                },
              )),
              SizedBox(height: 10,),
            ],
          );
        }
    );
  }

  //Destination Zone
  Widget _buildTab4View({required double screenWidth, required double screenHeight, required double textScale}){
    return Consumer(
        builder: (context, provider, child) {
          final destinations = ref.watch(_vm.destinationList);
          final selectedDest = ref.watch(_vm.slctdDestination);
          if(destinations.isEmpty){
            return Center(child: Text(AppStrings.noDataAvailable),);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: ListView.builder(
                shrinkWrap: true,
                itemCount: destinations.length,
                itemBuilder: (context, i) {
                  final current = destinations[i];
                  final desId = current["des_id"] ?? "";
                  final isSelected = selectedDest == desId;

                  return Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.mainClr,
                        value: isSelected,
                        onChanged: (bool? checked) {
                          if(checked == true) {
                            _vm.destinationOnChange(destinations[i]);
                          }
                        },
                      ),
                      Expanded(child: Text(current['des'] ?? '')),
                    ],
                  );
                },
              )),
              SizedBox(height: 10,),
            ],
          );
        }
    );
  }

  //Courier
  Widget _buildTab5View({required double screenWidth, required double screenHeight, required double textScale}){
    return Consumer(
        builder: (context, provider, child) {
          final couriers = ref.watch(_vm.courierList);
          final selectedCourier = ref.watch(_vm.slctdCourier);
          if(couriers.isEmpty){
            return Center(child: Text(AppStrings.noDataAvailable),);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: ListView.builder(
                shrinkWrap: true,
                itemCount: couriers.length,
                itemBuilder: (context, i) {
                  final current = couriers[i];
                  final payId = current["courier_id"] ?? "";
                  final isSelected = selectedCourier == payId;

                  return Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.mainClr,
                        value: isSelected,
                        onChanged: (bool? checked) {
                          if(checked == true) {
                            _vm.courierOnChange(couriers[i]);
                          }
                        },
                      ),
                      Expanded(child: Text(current['courier'] ?? '')),
                    ],
                  );
                },
              )),
              SizedBox(height: 10,),
            ],
          );
        }
    );
  }

  String getFilterLabel(Map<String, String> filter) {
    if (filter['pay_mode']?.isNotEmpty ?? false) return filter['pay_mode']!;
    if (filter['courier']?.isNotEmpty ?? false) return filter['courier']!;
    if (filter['range']?.isNotEmpty ?? false) return filter['range']!;
    if (filter['des']?.isNotEmpty ?? false) return filter['des']!;
    if ((filter['from']?.isNotEmpty ?? false) &&
        (filter['to']?.isNotEmpty ?? false)) {
      return '${filter['from']} to ${filter['to']}';
    }
    return '';
  }


}