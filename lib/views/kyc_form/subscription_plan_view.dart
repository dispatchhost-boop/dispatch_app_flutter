import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../const/common_methods.dart';
import '../../const/text_style.dart';
import '../../view_model/kyc_vm/profile_details_vm.dart';

class SubscriptionPlanView extends StatefulWidget {
  final TabController tabController;
  final ProfileDetailsViewModel profileVm;
  const SubscriptionPlanView({super.key, required this.tabController, required this.profileVm});

  @override
  State<SubscriptionPlanView> createState() => _SubscriptionPlanViewState();
}

class _SubscriptionPlanViewState extends State<SubscriptionPlanView> {
  // Helper function to constrain text size within min and max
  // double getResponsiveFontSize(double size, double min, double max) {
  //   return size.clamp(min, max);
  // }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;

    double headingFontSize = textScale * 15 ;
    double subHeadingFontSize = textScale * 14;

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            // No fixed minWidth, so it shrinks to content size
          ),
          child: Card(
            elevation: 3,
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Make column shrink to child heights
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MyTextStyles.getBoldText(
                          text: AppStrings.subscriptionPlan,
                          size: headingFontSize,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                        margin: EdgeInsets.only(right: screenWidth * 0.02),
                        constraints: BoxConstraints(
                          minHeight: screenHeight * 0.015, // relative minimum height
                          minWidth: screenWidth * 0.05,    // relative minimum width
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade100,
                          borderRadius: BorderRadius.circular(screenWidth * 0.01),
                        ),
                        child: Center(
                          child: MyTextStyles.getRegularText(
                            text: AppStrings.active,
                            clr: Colors.green,
                            size: subHeadingFontSize -1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  CommonMethods.getRowText(
                    heading: '${AppStrings.plan}: ',
                    subHeading: AppStrings.trialUpgrade,
                    style: 2,
                    headingSize: subHeadingFontSize,
                    subHeadingSize: subHeadingFontSize * 0.95,
                  ),
                  CommonMethods.getRowText(
                    heading: '${AppStrings.duration}: ',
                    subHeading: '15 Days',
                    style: 2,
                    headingSize: subHeadingFontSize,
                    subHeadingSize: subHeadingFontSize * 0.95,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
