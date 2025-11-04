import 'package:dispatch/api_client/api_url.dart';
import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/common_methods.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/view_model/dashboard_vm/filter_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/text_style.dart';
import '../../models/dashboard_model/overview_model.dart';
import '../../view_model/dashboard_vm/overview_vm.dart';

class OverviewTabview extends ConsumerStatefulWidget {
  // final Map<String, String> clientDetails;
  final OverviewViewModel vm;

  const OverviewTabview({super.key, required this.vm});

  @override
  ConsumerState<OverviewTabview> createState() => _OverviewTabviewState();
}

class _OverviewTabviewState extends ConsumerState<OverviewTabview> {
  late OverviewViewModel _vm;
  final List<String> filters = [
    "Overview",
    "Shipments",
    "RTO"
  ];
  String selecteddropDown = 'Shipped';

  @override
  void initState() {
    super.initState();
    // _vm = OverviewViewModel(ref);
    _vm = widget.vm;
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _vm.onFetchOverviewData(loaderRef: ref, loader: true);
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
          canPop: isLoading ? false : true, child: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDropDownAndFilter(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                SizedBox(height: screenHeight * 0.012,),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBusinessInsight(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                        _buildTodayOrders(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                        _buildTodayOrderValue(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                      ],
                    )
                ),
                SizedBox(height: screenHeight * 0.012,),
                // Payment mode, Shipping mode, Courier
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Modes
                        _getModesView<OrderSplitByPaymentMode>(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          textScale: textScale,
                          heading: "Order-split by Payment Mode",
                          list: ref.watch(_vm.overviewApiData)?.orderSplitByPaymentMode,
                          getName: (item) => item.paymentMode ?? "",
                          getTotal: (item) => item.total ?? 0,
                        ),
                        // Shipping Modes
                        _getModesView<ShipmentSplitByShippingMode>(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          textScale: textScale,
                          heading: "Shipment-split by Shipping Mode",
                          list: ref.watch(_vm.overviewApiData)?.shipmentSplitByShippingMode,
                          getName: (item) => item.shippingMode ?? "",
                          getTotal: (item) => item.total ?? 0,
                        ),

                        // Courier Modes
                        _getModesView<ShipmentSplitByCourier>(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          textScale: textScale,
                          heading: "Order-split by Courier",
                          list: ref.watch(_vm.overviewApiData)?.shipmentSplitByCourier,
                          // getName: (item) => "",
                          getName: (item) => item.imageUrl ?? "",
                          getTotal: (item) => item.total ?? 0,
                          showImage: true
                        ),

                      ],
                    )
                ),
                SizedBox(height: screenHeight * 0.018,),
                // Weight, TopStates, Delivery Performance
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weight
                        _getModesView<ShipmentSplitByWeight>(
                          minHeight: screenHeight * 0.32,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          textScale: textScale,
                          heading: "Order-split by Weight",
                          list: ref.watch(_vm.overviewApiData)?.shipmentSplitByWeight,
                          getName: (item) => item.weightBucket ?? "",
                          getTotal: (item) => item.total ?? 0,
                        ),
                        // Top 5 States
                        _getModesView<OrderSplitAcrossTopStates>(
                          minHeight: screenHeight * 0.32,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          textScale: textScale,
                          heading: "Order Split Across Top 5 States",
                          list: ref.watch(_vm.overviewApiData)?.orderSplitAcrossTopStates,
                          getName: (item) => item.state ?? "",
                          getTotal: (item) => item.totalOrders ?? 0,
                        ),

                        // // Delivery Performance
                        // _getModesView<DeliveryPerformance>(
                        //   screenWidth: screenWidth,
                        //   screenHeight: screenHeight,
                        //   textScale: textScale,
                        //   heading: "Delivery Performance",
                        //   list: ref.watch(_vm.overviewApiData)?.deliveryPerformance,
                        //   getName: (item) => item.delay ?? "",
                        //   getTotal: (item) => 0,
                        // ),
                        _getNDRView(minHeight: screenHeight * 0.32, screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale,
                            heading: 'Delivery Performance',
                            list: [
                              {
                                "color": Colors.lightGreen,
                                "text": "On-time Deliveries",
                                "count": ref.watch(_vm.overviewApiData)?.deliveryPerformance?[0].onTime ?? ''
                              },{
                                "color": Colors.red,
                                "text": "Delayed Deliveries",
                                "count": ref.watch(_vm.overviewApiData)?.deliveryPerformance?[0].delay ?? ''
                              },{
                                "color": Colors.blueAccent,
                                "text": "RTO",
                                "count": ref.watch(_vm.overviewApiData)?.deliveryPerformance?[0].rto ?? ''
                              }]),

                      ],
                    )
                ),
                SizedBox(height: screenHeight * 0.018,),
                // COD overview, NDR Overview, Shipment by NDR
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWithBoxView(
                            screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale, heading: 'Earned COD Overview', list: [
                          {
                            "icon": Icons.album,
                            "text": "COD amount earned",
                            "amount": "0"
                          },{
                            "icon": Icons.picture_as_pdf,
                            "text": "Earned COD remitted",
                            "amount": "0"
                          },{
                            "icon": Icons.currency_bitcoin,
                            "text": "COD amount available",
                            "amount": "0"
                          },
                          {
                            "icon": Icons.switch_access_shortcut,
                            "text": "Last remitted amount",
                            "amount": "0"
                          }]),
                        _buildWithBoxView(
                            screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale, heading: 'NDR Overview', list:
                        [
                          {
                            "icon": Icons.album,
                            "text": "Total NDR raised",
                            "amount": "0"
                          },{
                            "icon": Icons.picture_as_pdf,
                            "text": "Action Taken",
                            "amount": "0"
                          },{
                            "icon": Icons.currency_bitcoin,
                            "text": "Pending for action",
                            "amount": "0"
                          },
                          {
                            "icon": Icons.switch_access_shortcut,
                            "text": "NDR shipments delivered",
                            "amount": "0"
                          }]),
                        _getNDRView(minHeight: screenHeight * 0.32, screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale,
                            heading: 'Shipment-split by NDR',
                            list: [
                              {
                                "color": Colors.lightGreen,
                                "text": "NDR Shipments Delivered",
                                "count": ""
                              },{
                                "color": Colors.red,
                                "text": "RTO Requested",
                                "count": ""
                              },{
                                "color": Colors.blueAccent,
                                "text": "Re-Attempt Requests",
                                "count": ""
                              }]),
                      ],
                    )
                ),
                SizedBox(height: screenHeight * 0.08,),
              ],
            ),
          ),),
      ),);
        });
  }

  Widget _buildDropDownAndFilter({required double screenWidth, required double screenHeight, required double textScale, }){
    DashboardOverviewModel? apiData = ref.watch(_vm.overviewApiData);
    return Row(
      children: [
        Icon(Icons.select_all),
        SizedBox(width: screenWidth * 0.012,),
        DropdownButton<String>(
          value: selecteddropDown,
          isDense: true,
          alignment: Alignment.centerLeft,
          underline: const SizedBox(),
          iconEnabledColor: Colors.transparent, // hide default arrow
          iconDisabledColor: Colors.transparent,
          items: ['Shipped', 'Total Orders'].map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item),
                  if (item == selecteddropDown) ...[ // 👈 only show icon for selected
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_drop_down),
                  ]
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                selecteddropDown = value;
              });
            }
          },
        ),

        Spacer(),
        // GestureDetector(
        //     onTap: apiData != null ? (){
        //       // showModalBottomSheet(
        //       //   context: context,
        //       //   isScrollControlled: true,
        //       //   isDismissible: false,
        //       //   shape: const RoundedRectangleBorder(
        //       //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),//vertical(top: Radius.circular(22)
        //       //   ),
        //       //   builder: (context) {
        //       //     return FilterScreen(filterVm: widget.filterVm,);
        //       //   },
        //       // );
        //     } : null,
        //     child: Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(width: 0.5)
        //   ),
        //   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.003, horizontal: screenHeight * 0.006),
        //   child: Row(
        //     children: [
        //       Icon(Icons.filter_alt_outlined),
        //       Text('Filters'),
        //     ],
        //   ),
        // )),
        SizedBox(width: 8,),
      ],
    );
  }

  Widget _buildBusinessInsight({required double screenWidth, required double screenHeight, required double textScale}){
    BusinessInsightObj? apiData = ref.watch(_vm.overviewApiData)?.businessInsightObj;

    // final orderPer = getPercentageChange(initialValue: 100, finalValue: 800);
    final orderPer = CommonMethods.getPercentageChange(initialValue: apiData?.prevAvgOrders ?? 0.0, finalValue: apiData?.currentAvgOrders ?? 0.0);

    bool orderPositive = orderPer.contains('+');
    bool orderNegative = orderPer.contains('-');

    final valuePer = CommonMethods.getPercentageChange(initialValue: apiData?.prevAvgValue ?? 0.0, finalValue: apiData?.currentAvgValue ?? 0.0);

    bool valPositive = valuePer.contains('+');
    bool valNegative = valuePer.contains('-');

    return Container(
      constraints: BoxConstraints(
        minHeight: screenWidth >= 550 ? screenHeight * 0.22 : screenHeight * 0.27
      ),
      width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          Row(
            children: [
              MyTextStyles.getSemiBoldText(text: 'Business Insights', size: textScale * 15),
              Spacer(),
              MyTextStyles.getRegularText(text: AppStrings.lastThirtyDays, size: textScale * 15),
            ],
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextStyles.getSemiBoldText(text: apiData?.currentAvgOrders.toString() ?? '',),
                    MyTextStyles.getRegularText(text: 'Average Daily Orders', size: 14 * textScale),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.012), // spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: orderPositive ? '▲' : orderNegative ? '▼' : '', clr: orderPositive ? Colors.green : orderNegative ? Colors.red: Colors.transparent),),
                        MyTextStyles.getSemiBoldText(text: orderPer.replaceAll('+', '').replaceAll('-', ''))
                      ],
                    ),
                    MyTextStyles.getRegularText(text: 'vs previous 30 days', size: 13 * textScale, clr: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextStyles.getSemiBoldText(text: '\u20b9${double.tryParse(apiData?.currentAvgValue.toString() ?? '0')?.toStringAsFixed(2) ?? 0}'),
                    MyTextStyles.getRegularText(text: 'Average Order Value', size: 14 * textScale),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.012), // spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: valPositive ? '▲' : valNegative ? '▼' : '', clr: valPositive ? Colors.green : valNegative ? Colors.red: Colors.transparent),),
                        MyTextStyles.getSemiBoldText(text: valuePer.replaceAll('+', '').replaceAll('-', ''))
                      ],
                    ),
                    MyTextStyles.getRegularText(text: 'vs previous 30 days', size: 13 * textScale, clr: Colors.grey),
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

  Widget _buildTodayOrders({required double screenWidth, required double screenHeight, required double textScale}){
    OrderJsonResponse? apiData = ref.watch(_vm.overviewApiData)?.orderJsonResponse;
    if(apiData == null){
      return SizedBox();
    }
    final todayPercent = apiData.todayOrders?.percentage ?? 0.00;
    String todayPositive = CommonMethods.getSymbol(todayPercent.toString());
    final weekPercent = apiData.weekOrders?.percentage ?? 0.00;
    String weekPositive = CommonMethods.getSymbol(weekPercent.toString());
    final monthPercent = apiData.monthOrders?.percentage ?? 0.00;
    String monthPositive = CommonMethods.getSymbol(monthPercent.toString());
    final quarterPercent = apiData.quarterOrders?.percentage ?? 0.00;
    String quarterPositive = CommonMethods.getSymbol(quarterPercent.toString());
    return Container(
      constraints: BoxConstraints(
          minHeight: screenWidth >= 550 ? screenHeight * 0.22 : screenHeight * 0.27
      ),
      width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextStyles.getSemiBoldText(text: "Today's Orders", size: textScale * 14),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextStyles.getSemiBoldText(text: apiData.todayOrders?.count.toString() ?? '',),
              const SizedBox(width: 12), // spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: todayPositive, clr: todayPercent > 0 ? Colors.green : todayPercent < 0 ? Colors.red: Colors.black),),
                        MyTextStyles.getSemiBoldText(text: '$todayPercent %'),
                      ],
                    ),
                    MyTextStyles.getRegularText(text: 'vs yesterday', size: 13 * textScale, clr: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: 0.3,),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              MyTextStyles.getRegularText(text: 'This week (vs last week)', size: 14 * textScale),
              Spacer(),
              Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: weekPositive, clr: weekPercent > 0 ? Colors.green : weekPercent < 0 ? Colors.red: Colors.black)),
              MyTextStyles.getRegularText(text: '$weekPercent %', size: 15 * textScale),
            ],
          ),
          Row(
            children: [
              MyTextStyles.getRegularText(text: 'This month (vs last month)', size: 14 * textScale),
              Spacer(),
              Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: monthPositive, clr: monthPercent > 0 ? Colors.green : monthPercent < 0 ? Colors.red: Colors.black)),
              MyTextStyles.getRegularText(text: '$monthPercent%', size: 15 * textScale),
            ],
          ),
          Row(
            children: [
              MyTextStyles.getRegularText(text: 'This quarter (vs last quarter)', size: 14 * textScale),
              Spacer(),
              Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: quarterPositive, clr: quarterPercent > 0 ? Colors.green : quarterPercent < 0 ? Colors.red: Colors.black)),
              MyTextStyles.getRegularText(text: '$quarterPercent%', size: 15 * textScale),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildTodayOrderValue({required double screenWidth, required double screenHeight, required double textScale}){
    ValueJsonResponse? apiData = ref.watch(_vm.overviewApiData)?.valueJsonResponse;
    // final todayPercent = apiData?.todayValue?.percentage ?? 0.00;
    // String todayPositive = CommonMethods.getSymbol(todayPercent.toString());
    final weekPercent = apiData?.weekValue?.percentage ?? 0.00;
    String weekPositive = CommonMethods.getSymbol(weekPercent.toString());
    final monthPercent = apiData?.monthValue?.percentage ?? 0.00;
    String monthPositive = CommonMethods.getSymbol(monthPercent.toString());
    final quarterPercent = apiData?.quarterValue?.percentage ?? 0.00;
    String quarterPositive = CommonMethods.getSymbol(quarterPercent.toString());
    return Container(
      constraints: BoxConstraints(
          minHeight: screenWidth >= 550 ? screenHeight * 0.22 : screenHeight * 0.27
      ),
      width: screenWidth * 0.9,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextStyles.getSemiBoldText(text: "Today's Orders Value", size: textScale * 15),
          Divider(),
          MyTextStyles.getSemiBoldText(text: '\u20b9${apiData?.todayValue?.value ?? ''}',),
          SizedBox(height: screenHeight * 0.01),
          Divider(thickness: 0.3,),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Expanded(child: MyTextStyles.getRegularText(text: 'This week (vs last week)', size: 14 * textScale, overFlow: TextOverflow.visible)),
              // Spacer(),
              SizedBox(width: 10),
              MyTextStyles.getSemiBoldText(text: '\u20b9${apiData?.weekValue?.value ?? ''}', size: 14 * textScale, overFlow: TextOverflow.visible),
              SizedBox(width: 5),
              Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: weekPositive, clr: weekPercent > 0 ? Colors.green : weekPercent < 0 ? Colors.red: Colors.black),),
              MyTextStyles.getRegularText(text: '${weekPercent.toString().replaceAll('-', '')} %', size: 15 * textScale, overFlow: TextOverflow.visible),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: MyTextStyles.getRegularText(
                  text: 'This month (vs last month)',
                  size: 14 * textScale,
                  overFlow: TextOverflow.visible,
                ),
              ),
              SizedBox(width: 10),
              MyTextStyles.getSemiBoldText(
                text: '\u20b9${apiData?.monthValue?.value ?? ''}',
                size: 14 * textScale,
                overFlow: TextOverflow.visible,
              ),
              SizedBox(width: 5),
              Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: monthPositive, clr: monthPercent > 0 ? Colors.green : monthPercent < 0 ? Colors.red: Colors.black),),
              MyTextStyles.getRegularText(
                text: '${monthPercent.toString().replaceAll('-', '')} %',
                size: 15 * textScale,
                overFlow: TextOverflow.visible,
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                  child: MyTextStyles.getRegularText(text: 'This quarter (vs last quarter)', size: 14 * textScale, overFlow: TextOverflow.visible)),
              SizedBox(width: screenWidth * 0.1,),
              MyTextStyles.getSemiBoldText(text: '\u20b9${apiData?.quarterValue?.value ?? ''}', size: 14 * textScale, overFlow: TextOverflow.visible),
              Padding(padding: EdgeInsets.only(bottom: 3),child: MyTextStyles.getSemiBoldText(text: quarterPositive, clr: quarterPercent > 0 ? Colors.green : quarterPercent < 0 ? Colors.red: Colors.black),),
              MyTextStyles.getRegularText(text: '${quarterPercent.toString().replaceAll('-', '')} %', size: 15 * textScale, overFlow: TextOverflow.visible),
            ],
          ),

        ],
      ),
    );
  }

  Widget _getNDRView({double? minHeight, required double screenWidth, required double screenHeight, required double textScale, required String heading, required List<Map<String, dynamic>> list}){
    // List<OrderSplitByPaymentMode>? list = ref.watch(_vm.overviewApiData)?.;
    return Container(
      constraints: BoxConstraints(
          minHeight: minHeight ?? screenHeight * 0.26
      ),
      width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.015,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: MyTextStyles.getSemiBoldText(text: heading, size: textScale * 15)),
              // Spacer(),
              SizedBox(width: screenWidth * 0.01,),
              MyTextStyles.getRegularText(text: AppStrings.lastThirtyDays, size: textScale * 15),
            ],
          ),
          Divider(),
          SizedBox(height: screenHeight * 0.02,),
          if(list.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(),
              itemBuilder: (context, i){
                return Padding(padding: EdgeInsets.only(bottom: screenHeight * 0.006), child: Row(children: [
                  SizedBox(width: screenWidth * 0.02,),
                  Icon(Icons.circle, color: list[i]['color'], size: screenHeight * 0.024,),
                  SizedBox(width: screenWidth * 0.01,),
                  MyTextStyles.getRegularText(text: list[i]['text'] ?? '', size: 14 * textScale, overFlow: TextOverflow.visible),
                  Spacer(),
                  MyTextStyles.getSemiBoldText(text: list[i]['count'] ?? '', size: 15 * textScale, overFlow: TextOverflow.visible),
                  SizedBox(width: screenWidth * 0.02,),
                ],),);
              }, itemCount: list.length,),

        ],
      ),
    );
  }

  Widget _getModesView<T>({
    double? minHeight,
    required double screenWidth,
    required double screenHeight,
    required double textScale,
    required String heading,
    required List<T>? list,
    required String Function(T) getName,
    required num Function(T) getTotal,
    bool? showImage
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: minHeight ?? screenHeight * 0.26,
      ),
      width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.016,
        horizontal: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.015),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MyTextStyles.getSemiBoldText(
                  text: heading,
                  size: textScale * 15,
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              MyTextStyles.getRegularText(
                text: AppStrings.lastThirtyDays,
                size: textScale * 15,
              ),
            ],
          ),
          Divider(),
          SizedBox(height: screenHeight * 0.02),
          if (list != null && list.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final item = list[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.006),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: screenWidth * 0.02),
                      Icon(
                        Icons.circle,
                        color: i % 2 == 0 ? Colors.yellow : Colors.purple,
                        size: screenHeight * 0.024,
                      ),
                      SizedBox(width: 10),
                      if(showImage != true)
                      Expanded(child: MyTextStyles.getRegularText(
                        text: getName(item),
                        size: 14 * textScale,
                        overFlow: TextOverflow.visible,
                      )),

                      if(showImage == true && getName(item).isNotEmpty)
                        SizedBox(height: 20, width: 60,
                          child: Image.network('${ApiUrl.baseUrl}${getName(item)}')
                          ,),
                      if(showImage == true)
                      Spacer(),
                      MyTextStyles.getSemiBoldText(
                        text: getTotal(item).toString(),
                        size: 15 * textScale,
                        overFlow: TextOverflow.visible,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWithBoxView({double? minHeight, required double screenWidth, required double screenHeight, required double textScale, required String heading, required List<Map<String, dynamic>> list}){
    return Container(
      constraints: BoxConstraints(
          minHeight: minHeight ?? screenHeight * 0.26
      ),
      width: screenWidth * 0.85,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016, horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.015,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: MyTextStyles.getSemiBoldText(text: heading, size: textScale * 15)),
              // Spacer(),
              SizedBox(width: screenWidth * 0.01,),
              MyTextStyles.getRegularText(text: AppStrings.lastThirtyDays, size: textScale * 15),
            ],
          ),
          Divider(),
          SizedBox(height: screenHeight * 0.01,),
          if(list.isNotEmpty)
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            shrinkWrap:true, physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i){
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: screenWidth * 0.015, right: screenWidth * 0.01, top: screenHeight * 0.01, bottom: screenHeight * 0.01),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(width: 0.1, color: Colors.grey),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(list[i]['icon'] ?? Icons.add),
                  MyTextStyles.getSemiBoldText(text: "\u20b9${list[i]['amount']}", size: 15 * textScale, overFlow: TextOverflow.visible),
                  MyTextStyles.getRegularText(text: list[i]['text'], size: textScale * 13, overFlow: TextOverflow.ellipsis, maxLines: 2),
                ],
              ),
            );
          }, itemCount: 4,),

        ],
      ),
    );
  }

}
