import 'dart:io';
import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/common_widget.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/const/extensions.dart';
import 'package:dispatch/const/image_picker/image_pick_view.dart';
import 'package:dispatch/const/image_picker/my_media_picker.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:dispatch/services/login_credentials/user_authentications.dart';
import 'package:dispatch/view_model/kyc_vm/kyc_dashbord_vm.dart';
import 'package:dispatch/view_model/kyc_vm/profile_details_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../connectivity/internet_controller.dart';
import '../../const/app_colors.dart';
import '../../const/buttons.dart';
import '../../const/loader/loader_controller.dart';
import '../../services/live_face_detection/live_face_detect.dart';

class ProfileDetailsView extends ConsumerStatefulWidget {
  final TabController tabController;
  final KycDashboardViewModel kycVm;
  final ProfileDetailsViewModel vm;
  const ProfileDetailsView({super.key, required this.tabController, required this.vm, required this.kycVm});

  @override
  ConsumerState<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends ConsumerState<ProfileDetailsView> {

  // late ProfileDetailsViewModel _vm;
  // final TextEditingController _compName = TextEditingController();
  // final TextEditingController _brandName = TextEditingController();
  // final TextEditingController _compEmail = TextEditingController();
  // final TextEditingController _compWebsite = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    // _vm = ProfileDetailsViewModel(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    bool isBigSize = screenWidth >= 550;
    return Consumer(
        builder: (context, loader, _) {
          final isLoading = loader.watch(loadingProvider);
      return PopScope(
          canPop: isLoading ? false : true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight *0.1),
                Center(child: _buildPersonalDetails(ref: loader, screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),),
                // SizedBox(height: 35,),
                SizedBox(height: screenHeight * 0.05),
                _buildCompanyType(ref: loader, screenWidth: screenWidth, textScale: textScale),
                _buildBrandingDetails(ref: loader, screenHeight: screenHeight, screenWidth: screenWidth),
                _buildCompImagePicker(ref: loader),
                // SizedBox(height: 80,),
                SizedBox(height: screenHeight * 0.08),
                _buildUploadButton(screenWidth: screenWidth, screenHeight: screenHeight, textScale: textScale),
                SizedBox(height: isBigSize ? screenHeight * 0.07 : screenHeight * 0.045),
              ],
            ),
          ));
        },
    );
  }

  Widget _buildPersonalDetails({
    required WidgetRef ref,
    required double screenHeight,
    required double screenWidth,
    required double textScale,
  }) {
    String? profile = ref.watch(widget.vm.profileImage.notifier).state;
    bool? isPicked = ref.watch(widget.vm.isProfileNotPicked.notifier).state;
    final clientKycData = ref.watch(widget.kycVm.clientKycData.notifier).state;

    // Responsive sizing based on screen width
    double avatarSize = screenWidth * 0.3; // e.g., 30% of screen width for avatar
    avatarSize = avatarSize.clamp(100.0, 160.0); // clamp min and max size
    double iconSize = avatarSize * 0.45;
    double addBtnSize = avatarSize * 0.325;

    // Responsive text sizes with limits
    // double messageFontSize = (screenWidth * 0.03).clamp(12.0, 16.0);
    // double nameFontSize = (screenWidth * 0.046).clamp(16.0, 22.0);
    // double emailPhoneFontSize = (screenWidth * 0.042).clamp(14.0, 20.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: avatarSize,
          width: avatarSize,
          child: Stack(
            children: [
              Container(
                height: avatarSize * 0.9,
                width: avatarSize * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(avatarSize / 2),
                ),
                child: profile != null && profile.isNotEmpty
                    ? ClipOval(
                  child: Image.file(
                    File(profile),
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: iconSize,
                ),
              ),
              Positioned(
                bottom: addBtnSize * 0.2,
                right: addBtnSize * 0.3,
                child: GestureDetector(
                  onTap: () async {
                    final s = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return FaceDetectorScreenPage();
                    }));
                    if (s != null) {
                      final a = await MyMediaPicker.onSingleImageCompressor(imageFile: File(s));
                      ref.refresh(widget.vm.profileImage.notifier).state = a?.path ?? '';
                    }
                  },
                  child: Container(
                    height: addBtnSize,
                    width: addBtnSize,
                    decoration: BoxDecoration(
                      color: AppColors.mainClr,
                      borderRadius: BorderRadius.circular(addBtnSize / 2),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: addBtnSize * 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isPicked == true)
          Padding(
            padding: EdgeInsets.only(top: screenWidth * 0.015),
            child: MyTextStyles.getRegularText(
              text: AppStrings.pleaseCaptureProfilePhoto,
              clr: Colors.red,
              size: 12 * textScale,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenWidth * 0.016),
            child: MyTextStyles.getSemiBoldText(
              text: clientKycData?.userData?.firstName ?? '',
              size: 16 * textScale,
            ),
          ),
          MyTextStyles.getSemiBoldText(
            text: clientKycData?.userData?.email ?? '',
            size: 14 * textScale,
          ),
          MyTextStyles.getSemiBoldText(
            text: clientKycData?.userData?.phoneNo ?? '',
            size: 14 * textScale,
          ),
      ],
    );
  }

  Widget _buildBrandingDetails({required WidgetRef ref, required double screenHeight, required double screenWidth}){
    final companyType = ref.watch(widget.vm.companyType.notifier).state;
    if(companyType == null) {
      return SizedBox.shrink();
    } else if(companyType == 4) {
      return SizedBox.shrink();
    }
    return Form(
      key: widget.vm.formKey,
        child: SizedBox(
            width: screenWidth * 0.8,
            child:Column(
        children: [
          CommonWidget.buildTextField(controller: widget.vm.compName, label: '${AppStrings.registeredCompanyName} *', hint: AppStrings.enterCompanyName, validator: true),
          SizedBox(height: screenHeight * 0.012,),
          CommonWidget.buildTextField(controller: widget.vm.brandName, label: AppStrings.brandName, hint: AppStrings.enterBrandName),
          SizedBox(height: screenHeight * 0.012,),
          CommonWidget.buildTextField(controller: widget.vm.compEmail, label: '${AppStrings.companyEmailId} *', hint: AppStrings.companyEmailHint, validator: true, customValidator: (v) {
            if (v == null || v.isEmpty) {
              return AppStrings.required;
            }else if(!v.isValidEmail()){
              return AppStrings.enterValidEmailAddress;
            }
            return null; // ✅ valid input
          }),
          SizedBox(height: screenHeight * 0.012,),
          CommonWidget.buildTextField(controller: widget.vm.compWebsite, label: AppStrings.website, hint: AppStrings.websiteHint),
        ],
    )));
  }

  Widget _buildCompanyType({
    required WidgetRef ref,
    required double screenWidth,
    required double textScale,
  }) {
    final compType = ref.watch(widget.vm.companyType.notifier).state;
    final isNotSelected = ref.watch(widget.vm.isCompTypeNotSelected.notifier).state;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Add border or background if needed
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextStyles.getSemiBoldText(
                text: AppStrings.chooseCompanyType,
                size: 15 * textScale,
              ),
              MyTextStyles.getSemiBoldText(
                text: ' *',
                clr: Colors.red,
                size: textScale * 15,
              ),
            ],
          ),
          RadioListTile<int>(
            dense: true,
            activeColor: AppColors.mainClr,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: MyTextStyles.getRegularText(
              text: AppStrings.privateCompany,
              size: 14 * textScale,
            ),
            value: 1,
            groupValue: compType,
            onChanged: (value) {
              ref.refresh(widget.vm.companyType.notifier).state = value;
            },
          ),
          RadioListTile<int>(
            dense: true,
            activeColor: AppColors.mainClr,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: MyTextStyles.getRegularText(
              text: AppStrings.publicCompany,
              size: 14 * textScale,
            ),
            value: 2,
            groupValue: compType,
            onChanged: (value) {
              ref.refresh(widget.vm.companyType.notifier).state = value;
            },
          ),
          RadioListTile<int>(
            dense: true,
            activeColor: AppColors.mainClr,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: MyTextStyles.getRegularText(
              text: AppStrings.partnership,
              size: 14 * textScale,
            ),
            value: 3,
            groupValue: compType,
            onChanged: (value) {
              ref.refresh(widget.vm.companyType.notifier).state = value;
            },
          ),
          RadioListTile<int>(
            dense: true,
            activeColor: AppColors.mainClr,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: MyTextStyles.getRegularText(
              text: AppStrings.individual,
              size: 14 * textScale,
            ),
            value: 4,
            groupValue: compType,
            onChanged: (value) {
              ref.refresh(widget.vm.companyType.notifier).state = value;
            },
          ),
          if (isNotSelected == true)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: MyTextStyles.getRegularText(
                text: AppStrings.isMandatoryToChoose,
                clr: Colors.red,
                size: 14 * textScale,
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildCompImagePicker({required WidgetRef ref}) {
    final imagePath = ref.watch(widget.vm.compImage.notifier).state;
    final isRequired = ref.watch(widget.vm.isCompImageRequired.notifier).state;
    return onImagePickView(
        context: context,
        imagePath: imagePath,
        isRequired: isRequired,
        onMainBoxTap: () {
      widget.vm.onPickCompImage(context: context);
    }, onRemovePressed: () {
      widget.vm.removeCompImage();
    });
  }

  Widget _buildUploadButton({required double screenWidth, required double screenHeight, required double textScale}) {
    return Consumer(builder: (key, ref, child){
      final hasConnection = ref.watch(internetProvider).hasConnection;
      final compType = ref.watch(widget.vm.companyType.notifier).state;
      final isProfile = ref.watch(widget.vm.profileImage.notifier).state;
      final compImage = ref.watch(widget.vm.compImage.notifier).state;
      Future<void> saveAndNext(Map<String, String> data) async {
        ref.read(widget.kycVm.profileDetails.notifier).state = data;
        widget.tabController.animateTo(1);
      }
      return AppButtons.buildContainerButton(
          text: AppStrings.save,
          height: screenHeight * 0.06,
          width: screenWidth * 0.8,
          onTap: () async {
            if (!hasConnection) return;

            FocusScope.of(context).unfocus();

            if (isProfile == null) {
              ref.refresh(widget.vm.isProfileNotPicked.notifier).state = true;
              return;
            }

            ref.refresh(widget.vm.isProfileNotPicked.notifier).state = false;

            if (compType == null) {
              ref.refresh(widget.vm.isCompTypeNotSelected.notifier).state = true;
              return;
            }

            ref.refresh(widget.vm.isCompTypeNotSelected.notifier).state = false;

            if (compImage == null) {
              ref.refresh(widget.vm.isCompImageRequired.notifier).state = true;
              return;
            }

            ref.refresh(widget.vm.isCompImageRequired.notifier).state = false;

            if (compType == 4) {
              await saveAndNext({
                "image": '${ref.read(widget.vm.profileImage.notifier).state}',
                "comp_type": '${ref.read(widget.vm.companyType.notifier).state}',
                "comp_image": '${ref.read(widget.vm.compImage.notifier).state}',});
              return;
            }

            if (widget.vm.formKey.currentState?.validate() ?? false) {
              DebugConfig.debugLog('Personal Det. form validate');
              final data = {
                "image": '${ref.read(widget.vm.profileImage.notifier).state}',
                "comp_type": '${ref.read(widget.vm.companyType.notifier).state}',// 1 for private, 2 for public, 3 for partnership, 4 for individual
                "comp_image": '${ref.read(widget.vm.compImage.notifier).state}',
                "comp_name": widget.vm.compName.text,
                "brand_name": widget.vm.brandName.text,
                "comp_email": widget.vm.compEmail.text,
                "comp_website": widget.vm.compWebsite.text,
              };
              await saveAndNext(data);
            }
          }

      );
    });
  }

}
