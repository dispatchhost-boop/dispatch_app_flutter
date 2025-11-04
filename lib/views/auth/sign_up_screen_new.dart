
import 'package:dispatch/const/debug_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../connectivity/internet_controller.dart';
import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../const/buttons.dart';
import '../../const/circle_check_box.dart';
import '../../const/common_widget.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/loader/loader_screen.dart';
import '../../const/text_style.dart';
import '../../view_model/auth_vm/sign_up_vm.dart';
import '../../const/extensions.dart';
import '../../views/auth/login_screen.dart';

class SignUpScreenNew extends ConsumerStatefulWidget {
  const SignUpScreenNew({super.key});

  @override
  ConsumerState<SignUpScreenNew> createState() => _SignUpScreenNewState();
}

class _SignUpScreenNewState extends ConsumerState<SignUpScreenNew> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _orgName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late SignUpViewModel _vm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vm = SignUpViewModel(ref);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    return Consumer(
      builder: (context, loader, _) {
        final isLoading = loader.watch(loadingProvider);

        return PopScope(
          canPop: isLoading ? false : true,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(screenWidth: screenWidth, textScale: textScale),
                        SizedBox(height: screenHeight * 0.04),
                        _buildTextFields(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                        SizedBox(height: screenHeight * 0.02),
                        _buildTermsAndConditions( context: context, screenWidth: screenWidth, textScale: textScale),
                        SizedBox(height: screenHeight * 0.03),
                        _buildSignUpButton(loaderRef: loader, screenWidth: screenWidth, screenHeight: screenHeight),
                        SizedBox(height: screenHeight * 0.06),
                        _buildSignUpText(context: context, textScale: textScale),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Align(
                  alignment: Alignment.center,
                  child: Loader(),
                )
            ],
          ),
        );
      },
    );
  }


  Widget _buildHeader({required double screenWidth, required double textScale}) {
    return SizedBox(
      width: screenWidth * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTextStyles.getBoldText(text: AppStrings.createYourLogisticsPartnerAccount, size: 25 + textScale, clr: AppColors.mainClr),
          MyTextStyles.getRegularText(text: AppStrings.joinOurNetworkAndStreamlineYourShippingOperations),
        ],
      ),
    );
  }

  Widget _buildTextFields({required double screenHeight, required double screenWidth, required double textScale}) {
    return SizedBox(
      width: screenWidth * 0.8,
      // height: 320,
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonWidget.buildTextField(
                  controller: _userName, label: '${AppStrings.fullName} *', hint: 'John Doe', validator: true),
              SizedBox(height: screenHeight * 0.012),
              CommonWidget.buildTextField(
                  controller: _orgName, label: '${AppStrings.organizationName} *', hint: 'Acme Inc.', validator: true),
              SizedBox(height: screenHeight * 0.012),
              CommonWidget.buildTextField(
                  controller: _email, label: '${AppStrings.workEmailAddress} *', hint: 'you@company.com', validator: true, customValidator: (v) {
                if (v == null || v.isEmpty) {
                  return AppStrings.required;
                }else if(!v.isValidEmail()){
                  return AppStrings.enterValidEmailAddress;
                }
                return null; // ✅ valid input
              }),
              SizedBox(height: screenHeight * 0.012),
              CommonWidget.buildTextField(
                  controller: _phone, label: '${AppStrings.phoneNumber} *', hint: '+1 (555) 123-4567', validator: true, customValidator: (v){
                if (v == null || v.isEmpty) {
                  return AppStrings.required;
                }
                if(v.length < 10){
                  return AppStrings.enterValidPhoneNumber;
                }return null;
              },keyboardType: TextInputType.number, inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ]),
              SizedBox(height: screenHeight * 0.012),
              Consumer(builder: (key, ref, child){
                final slctdSegment = ref.watch(_vm.selectedSegment); // <-- gets value
                final slctdCategory = ref.watch(_vm.selectedCategory);
                final slctdVol = ref.watch(_vm.selectedVol); // <-- gets value
                final slctdShipment = ref.watch(_vm.selectedShipment);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: CommonWidget.buildDropDown(label: '${AppStrings.segmentType} *', items: _vm.segmentList, onChanged: (v){
                          _vm.segmentOnChange(v.toString());
                        }, hint: AppStrings.select, fontSize: 15, value: slctdSegment, validator: true)),
                        SizedBox(width: 10),
                        Expanded(child: CommonWidget.buildDropDown(label: '${AppStrings.businessCategory} *', items: _vm.categoryList, onChanged: (v){
                          _vm.categoryOnChange(v.toString());
                        }, hint: AppStrings.select, fontSize: 15, value: slctdCategory, validator: true)),
                      ],
                    ),
                    if(slctdSegment == 'Express' || slctdSegment == 'Ecom')
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenHeight * 0.012),
                        if(slctdSegment == 'Ecom')
                        CommonWidget.buildDropDown<Map<String, String>>(
                        label: '${AppStrings.noOfShipmentPerMonth} *',
                        items: _vm.shipmentsList,
                        hint: AppStrings.select,
                        fontSize: 15,
                        validator: true,
                        value: slctdShipment == null
                        ? null : _vm.shipmentsList.firstWhere(
                        (element) => element['id'] == slctdShipment['id'],
                        ),
                        displayItem: (v) {
                          return v['ship'] ?? '';
                        },
                        onChanged: (v) {
                          if (v != null) {
                            ref.read(_vm.selectedShipment.notifier).state = v;
                            }
                          },
                        ),
                        if(slctdSegment == 'Express')
                        CommonWidget.buildDropDown<Map<String, String>>(
                          label: '${AppStrings.businessVolume} *',
                          items: _vm.volumeList,
                          hint: AppStrings.select,
                          fontSize: 15 + textScale,
                          validator: true,
                          value: slctdVol == null
                              ? null : _vm.volumeList.firstWhere(
                                (element) => element['id'] == slctdVol['id'],
                          ),
                          displayItem: (v) {
                            return v['volume'] ?? '';
                          },
                          onChanged: (v) {
                            if (v != null) {
                              ref.read(_vm.selectedVol.notifier).state = v;
                            }
                          },
                        ),
                      ],
                    )
                  ],
                );
              }),
              SizedBox(height: screenHeight * 0.012),
              CommonWidget.buildTextField(
                  controller: _password, label: '${AppStrings.password} *', hint: AppStrings.createStrongPassword, validator: true, customValidator: (v) {
                    return v?.isValidPassword(v);
              }, inputFormatters: [
                LengthLimitingTextInputFormatter(12)
              ]),
              SizedBox(height: screenHeight * 0.012),
            ],
          )),
    );
  }

  Widget _buildTermsAndConditions({required BuildContext context, required double screenWidth, required double textScale}) {
    return Center(child: SizedBox(
      width: screenWidth * 0.8,
      // height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(builder: (key, ref, child){
            final checkStatus = ref.watch(_vm.agreeCheck);
            return CircleCheckbox(
                value: checkStatus, onChanged: (v){
                  ref.refresh(_vm.agreeCheck.notifier).state = v ?? false;
            });
          }),
          SizedBox(width: screenWidth * 0.04),
          Expanded(child: Consumer(builder: (key, ref, child){
            final showRequired = ref.watch(_vm.agreeCheckRequired);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: AppStrings.iAgreeToThe,
              style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.75),
                  fontSize: 14 + textScale,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  overflow: TextOverflow.ellipsis
              ),
              children: [
                MyTextStyles.getTextSpan(text: AppStrings.privacyPolicy, textClr: AppColors.mainClr, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                MyTextStyles.getTextSpan(text: " ${AppStrings.and} ", fontWeight: FontWeight.normal),
                MyTextStyles.getTextSpan(text: AppStrings.termsOfService, textClr: AppColors.mainClr, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
              ],
            ),
          ),
              if(showRequired)
              MyTextStyles.getRegularText(text: AppStrings.pleaseCheckThisBoxIfYouWantToProceed, clr: Colors.red.shade800, size: 12 + textScale)
                ],
                ),
                );
              })
          )
        ],
      ),
    ),
    );
  }

  Widget _buildSignUpButton({required WidgetRef loaderRef, required double screenWidth, required double screenHeight}) {
    return Consumer(builder: (key, ref, child){
      final isAgreeReq = ref.watch(_vm.agreeCheck);
      final hasConnection = ref.watch(internetProvider).hasConnection;
      return AppButtons.buildContainerButton(
        text: AppStrings.signUp,
        height: screenHeight * 0.06,
        width: screenWidth * 0.8,
        onTap: () async{
            if(!isAgreeReq){
              ref.refresh(_vm.agreeCheckRequired.notifier).state = true;
            }else{
              ref.refresh(_vm.agreeCheckRequired.notifier).state = false;
            }
            if(_formKey.currentState!.validate() && isAgreeReq && hasConnection){
              final body ={
                "name": _userName.text,
                "organization": _orgName.text,
                "email": _email.text,
                "password": _password.text,
                "company_type": ref.read(_vm.selectedCategory.notifier).state.toString().toLowerCase(),
                "segment_type": ref.read(_vm.selectedSegment.notifier).state.toString().toLowerCase(),
                "phone": _phone.text,
                "monthly_parcels": ref.read(_vm.selectedShipment.notifier).state?['id']?.toString() ?? '',
                "business_volume": ref.read(_vm.selectedVol.notifier).state?['id']?.toString() ?? '',
              };
              if(ref.read(_vm.selectedShipment.notifier).state != null){
                body.removeWhere((k, v) => k == 'business_volume');
              }else if(ref.read(_vm.selectedVol.notifier).state != null){
                body.removeWhere((k, v) => k == 'monthly_parcels');
              }
              final res = await _vm.fetchCreateAccount(loaderRef: ref, body: body);
              if(res!= null){
                _userName.clear();
                _orgName.clear();
                _email.clear();
                _password.clear();
                _phone.clear();
                ref.refresh(_vm.selectedSegment.notifier).state = null;
                ref.refresh(_vm.selectedCategory.notifier).state =null;
                ref.refresh(_vm.selectedShipment.notifier).state = null;
                ref.refresh(_vm.selectedVol.notifier).state = null;
                ref.refresh(_vm.agreeCheck.notifier).state = false;
                ref.refresh(_vm.agreeCheckRequired.notifier).state = false;
              }

            }
        },
      );
    });
  }

  Widget _buildSignUpText({required BuildContext context, required double textScale}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: AppStrings.haveAnAccount,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.75),
          fontSize: 14 + textScale,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
        children: [
          MyTextStyles.getTextSpan(text: " ${AppStrings.signIn}", fontWeight: FontWeight.w600, textClr: AppColors.mainClr, size: 15+ textScale, onTap: () {
            DebugConfig.debugLog("Sign In tapped!");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return LogInScreen();
            }));
          })
        ],
      ),
    );
  }

}
