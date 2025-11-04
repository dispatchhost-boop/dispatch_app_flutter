import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/view_model/dashboard_vm/shipment_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/app_colors.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/text_style.dart';
import '../../view_model/dashboard_vm/filter_vm.dart';
import '../../view_model/dashboard_vm/overview_vm.dart';
import 'filter_screen.dart';

class RtoTabview extends ConsumerStatefulWidget {
  final DashBoardFilterViewModel filterVm;
  const RtoTabview({super.key, required this.filterVm});

  @override
  ConsumerState<RtoTabview> createState() => _RtoTabviewState();
}

class _RtoTabviewState extends ConsumerState<RtoTabview> {
  // late ShipmentViewModel _vm;

  @override
  void initState() {
    super.initState();
    // _vm = ShipmentViewModel(ref);/
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApplyFilter(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                    SizedBox(height: screenHeight * 0.012,),
                    _buildRtoSummary(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale, list: [
                      {
                        "icon": Icons.album,
                        "text": "Total Orders",
                        "count": "0",
                        "percent": ""
                      },{
                        "icon": Icons.picture_as_pdf,
                        "text": "Total RTO",
                        "count": "14",
                        "percent": "51.85"
                      },{
                        "icon": Icons.currency_bitcoin,
                        "text": "RTO Initiated",
                        "count": "0",
                        "percent": "0"
                      },
                      {
                        "icon": Icons.switch_access_shortcut,
                        "text": "RTO Transit",
                        "count": "5",
                        "percent": "18.52"
                      }, {
                        "icon": Icons.album,
                        "text": "RTO Delivered",
                        "count": "0",
                        "percent": "0"
                      }]),
                    SizedBox(height: 16,),
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
                  return FilterScreen(filterVm: widget.filterVm,);
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

  Widget _buildRtoSummary({required double screenWidth, required double screenHeight, required double textScale, required List<Map<String, dynamic>> list}) {
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
          MyTextStyles.getSemiBoldText(
              text: 'Order Summary', size: textScale * 15),
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
                mainAxisExtent: 170,
              ),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
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
                            child: Icon(list[i]['icon'] ?? Icons.add),
                          ),
                          MyTextStyles.getSemiBoldText(
                            text: list[i]['count'],
                            size: 20,
                            // maxLines: 2
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      if(list[i]['percent']
                          .toString()
                          .isNotEmpty)
                        MyTextStyles.getRegularText(
                          text: '${list[i]['percent']}%',
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
              },
              itemCount: list.length,),)
        ],
      ),
    );
  }

}
