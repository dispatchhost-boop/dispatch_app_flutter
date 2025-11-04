import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:dispatch/view_model/dashboard_vm/filter_vm.dart';
import 'package:dispatch/view_model/dashboard_vm/shipment_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/app_colors.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/text_style.dart';
import '../../view_model/dashboard_vm/overview_vm.dart';
import 'filter_screen.dart';

class ShipmentTabview extends ConsumerStatefulWidget {
  final DashBoardFilterViewModel filterVm;
  final ShipmentViewModel shipmentVm;
  const ShipmentTabview({super.key, required this.filterVm, required this.shipmentVm});

  @override
  ConsumerState<ShipmentTabview> createState() => _ShipmentTabviewState();
}

class _ShipmentTabviewState extends ConsumerState<ShipmentTabview> {
  late ShipmentViewModel _vm;
  late final body;
  // final userAuth = UserAuthentication();

  @override
  void initState() {
    super.initState();
    _vm = widget.shipmentVm;
    // _vm = ShipmentViewModel(ref);
    WidgetsBinding.instance.addPostFrameCallback((_){
      // final appliedFilterList = ref.read(widget.filterVm.selectedFiltersList.notifier).state;
      // final quickRange = ref.read(widget.filterVm.quickRangeVal.notifier).state;
      // DebugConfig.debugLog('Applied Filter list :: $appliedFilterList');
      // String sltdPaymentMode = widget.filterVm.getFilterValue(appliedFilterList, "pay_id", "pay_mode");
      // String sltdDest = widget.filterVm.getFilterValue(appliedFilterList, "des_id", "des");
      // String sltdCourier = widget.filterVm.getFilterValue(appliedFilterList, "courier_id", "courier");
      // String sltdQuickRange = widget.filterVm.getFilterValue(appliedFilterList, "range_id", "range");
      //
      // DebugConfig.debugLog('Selelerd pay : $sltdPaymentMode');
      // DebugConfig.debugLog('Selelerd des : $sltdDest');
      // DebugConfig.debugLog('Selelerd courier : $sltdCourier');
      // DebugConfig.debugLog('Selelerd quick range : $sltdQuickRange');
      //
      // body = {
      //   "courier_type": "ecom",
      //   "quickRange": quickRange != null ? sltdQuickRange : "",
      //   "payment_mode": sltdPaymentMode,
      //   "destination_zone": sltdDest,
      //   "tagged_api": ""
      // };
      //
      // // ✅ Add extra keys if quickRange is null
      // if (quickRange == null) {
      //   body["fromDate"] = widget.filterVm.fromDate.text.toString();
      //   body["toDate"] = widget.filterVm.toDate.text.toString();
      // }
      //
      // DebugConfig.debugLog('UserAuth idd :: ${userAuth.id}');
      // // final clientDet = {
      // //   "client_id": userAuth.id != null ? userAuth.id.toString() : '',
      // //   "level": userAuth.level != null ? userAuth.level.toString() : '',
      // // };
      // final clientDet = userAuth.getClientDetails(userAuth.id != null ? userAuth.id.toString() : '', userAuth.level != null ? userAuth.level.toString() : '');
      // _vm.fetchShipmentData(body: body, loaderRef: ref, clientDetails: clientDet);


      widget.filterVm.getShipmentDetailsData(ref, widget.shipmentVm);


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
          final apiData = loader.watch(_vm.shipmentData);
          return PopScope(
            canPop: isLoading ? false : true, child: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApplyFilter(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                    SizedBox(height: screenHeight * 0.012,),
                    _buildOrderSummary(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale, list: [
                      {
                        "icon": Icons.shopping_basket,
                        "icon_clr": AppColors.mainClr,
                        "text": "Total Orders",
                        "count": apiData?.totalOrders ?? '',
                        "percent": ""
                      },{
                        "icon": Icons.shopping_cart,
                        "icon_clr": Colors.green,
                        "text": "Ready to Dispatch",
                        "count": apiData?.readyToDispatch ?? '',
                        "percent": apiData?.percent?.readyToDispatch ?? ''
                      },{
                        "icon": Icons.local_post_office,
                        "icon_clr": Colors.orange,
                        "text": "Ready to Dispatch (Post)Ready to Dispatch (Post)",
                        "count": apiData?.readyToDispatchPost ?? '',
                        "percent": apiData?.percent?.readyToDispatchPost ?? ''
                      },
                      {
                        "icon": Icons.transit_enterexit,
                        "icon_clr": AppColors.mainClr,
                        "text": "In Transit",
                        "count": apiData?.inTransit ?? '',
                        "percent": apiData?.percent?.inTransit ?? ''
                      }, {
                        "icon": Icons.car_rental,
                        "icon_clr": Colors.lightBlue,
                        "text": "Out for Delivery",
                        "count": apiData?.outForDelivery ?? '',
                        "percent": apiData?.percent?.outForDelivery ?? ''
                      },{
                        "icon": Icons.check,
                        "icon_clr": Colors.green,
                        "text": "Delivered",
                        "count": apiData?.delivered ?? '',
                        "percent": apiData?.percent?.delivered ?? ''
                      },{
                        "icon": Icons.transcribe,
                        "icon_clr": Colors.purple,
                        "text": "RTO In-Transi",
                        "count": apiData?.rtoInTransit ?? '',
                        "percent": apiData?.percent?.rtoInTransit ?? ''
                      },
                      {
                        "icon": Icons.refresh,
                        "icon_clr": Colors.orangeAccent,
                        "text": "RTO",
                        "count": apiData?.rto ?? '',
                        "percent": apiData?.percent?.rto ?? ''
                      },{
                        "icon": Icons.no_encryption,
                        "icon_clr": Colors.red,
                        "text": "NDR",
                        "count": apiData?.ndr ?? '',
                        "percent": apiData?.percent?.ndr ?? ''
                      }]),
                    SizedBox(height: 16,),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShippingMode(minHeight: isBigSize ? 335 : screenHeight * 0.34 , screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale,
                            heading: 'Shipment-split by Shipping Mode',
                            list: [
                              {
                                "text": "Air",
                                "count": "0"
                              },{
                                "text": "Surface",
                                "count": "0"
                              }]),
                        SizedBox(width: 16,),
                        _buildZone(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale,
                            heading: 'Shipment-split by Shipping Mode'),
                      ],
                    )),
                    SizedBox(height: screenHeight * 0.08,),
                  ],
                ),
              ),),
          ),);
        });
  }

  Widget _buildApplyFilter({required double screenWidth, required double screenHeight, required double textScale, }){
    return Row(
      children: [
        Spacer(),
        GestureDetector(
            onTap: (){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),//vertical(top: Radius.circular(22)
                ),
                builder: (context) {
                  return FilterScreen(filterVm: widget.filterVm, shipmentVm: _vm,);
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.5)
              ),
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.003, horizontal: screenHeight * 0.006),
              child: Row(
                children: [
                  Icon(Icons.filter_alt_outlined),
                  Text('Filters'),
                ],
              ),
            )),
        SizedBox(width: 8,),
      ],
    );
  }

  Widget _buildOrderSummary({required double screenWidth, required double screenHeight, required double textScale, required List<Map<String, dynamic>> list}){
    bool isBigSize = screenWidth >= 550;
    return Container(
      constraints: BoxConstraints(
          minHeight: screenHeight * 0.26
      ),
      // width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextStyles.getSemiBoldText(text: 'Order Summary', size: textScale * 15),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(
            height: 260,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 200,
              ),
            shrinkWrap:true,
            itemBuilder: (context, i){
              return Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(width: 0.1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: list[i]['icon_clr'] ?? AppColors.mainClr,
                          child: Icon(list[i]['icon'] ?? Icons.add, size: 20, color: AppColors.white,),
                        ),
                        MyTextStyles.getSemiBoldText(
                          text: list[i]['count'].toString(),
                          size: 20,
                          // maxLines: 2
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    MyTextStyles.getRegularText(
                      text: list[i]['text'] != 'Total Orders' ? '${list[i]['percent']}%' : '',
                      size: 14,
                      overFlow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5),
                    MyTextStyles.getSemiBoldText(
                          text: list[i]['text'],
                          size: 13,
                          maxLines: 2,
                          overFlow: TextOverflow.ellipsis
                        ),
                  ],
                ),
              );
            }, itemCount: list.length,),)
        ],
      ),
    );
  }

  Widget _buildShippingMode({double? minHeight, required double screenWidth, required double screenHeight, required double textScale, required String heading, required List<Map<String, dynamic>> list}){
    return Container(
      constraints: BoxConstraints(
          minHeight: minHeight ?? screenHeight * 0.18
      ),
      width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12,),
          MyTextStyles.getSemiBoldText(text: heading, size: 15),
          Divider(),
          SizedBox(height: screenHeight * 0.02,),
          if(list.isNotEmpty)
            ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(),
            itemBuilder: (context, i){
              return Padding(padding: EdgeInsets.only(bottom: screenHeight * 0.006), child: Row(children: [
                SizedBox(width: 8,),
                MyTextStyles.getRegularText(text: '${list[i]['text']}:', size: 14 * textScale, overFlow: TextOverflow.visible),
                // Spacer(),
                SizedBox(width: 8,),
                MyTextStyles.getSemiBoldText(text: list[i]['count'], size: 15 * textScale, overFlow: TextOverflow.visible),
                SizedBox(width: 12,),
              ],),);
            }, itemCount: list.length,),

        ],
      ),
    );
  }

  Widget _buildZone({double? minHeight, required double screenWidth, required double screenHeight, required double textScale, required String heading}){
    return Consumer(builder: (key, builder, child){
      List<Map<String, String>> list = builder.read(_vm.zonesList);
      final slctdZone = builder.watch(_vm.selectedZone);
      return Container(
        constraints: BoxConstraints(
            minHeight: minHeight ?? screenHeight * 0.18
        ),
        width: screenWidth * 0.85,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12,),
            MyTextStyles.getSemiBoldText(text: heading, size: 15),
            Divider(),
            if(list.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final current = list[i];
                  final id = current["id"] ?? "";
                  final isSelected = slctdZone == id;

                  return Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.mainClr,
                        value: isSelected,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 reduces vertical padding
                        // visualDensity: VisualDensity.compact, // 👈 makes it more compact vertically
                        onChanged: (bool? checked) {
                            _vm.zoneOnChange(list[i]);
                        },
                      ),
                      Expanded(child: Text(current['zone'] ?? '')),
                    ],
                  );
                },
              ),

          ],
        ),
      );
    });
  }

}
