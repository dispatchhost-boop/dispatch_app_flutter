
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/const/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../connectivity/internet_controller.dart';
import '../../const/buttons.dart';
import '../../const/common_widget.dart';
import '../../const/loader/loader_screen.dart';
import '../../const/text_style.dart';
import '../../view_model/auth_vm/login_vm.dart';
import '../../views/auth/forgot_password.dart';
import '../../views/auth/sign_up_screen_new.dart';
import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../const/circle_check_box.dart';
import '../../const/loader/loader_controller.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {

  late LoginViewModel _vm;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vm = LoginViewModel(ref);
    WidgetsBinding.instance.addPostFrameCallback((_){
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom], // Show only top bar
      );
    });
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
                        _buildHeader(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                        SizedBox(height: screenHeight * 0.04),
                        _buildTextFields(screenWidth: screenWidth, textScale: textScale),
                        SizedBox(height: screenHeight * 0.02),
                        _buildRememberForgotRow(context: context, screenWidth: screenWidth, textScale: textScale),
                        SizedBox(height: screenHeight * 0.05),
                        _buildSignInButton(ref: loader, screenWidth: screenWidth, screenHeight: screenHeight),
                        // const SizedBox(height: 20),
                        // _buildSocialLoginButton(),
                        SizedBox(height: screenHeight * 0.15),
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

  Widget _buildHeader(
      {required double screenHeight, required double screenWidth, required double textScale}) {
    return SizedBox(
      width: screenWidth * 0.8, //320,
      // height: 134,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Image.asset('assets/images/png/dispatch.png', height: screenHeight * 0.1,),),
          SizedBox(height: screenHeight * 0.05),
          MyTextStyles.getBoldText(text: AppStrings.loginToDispatchSolutions, size: 18 * textScale),
          MyTextStyles.getRegularText(
            text: AppStrings.signInToContinue,
            size: 15 * textScale, clr: Colors.grey
          ),
        ],
      ),
    );
  }

  Widget _buildTextFields({required double screenWidth, required double textScale}) {
    return SizedBox(
      width: screenWidth * 0.8,
      // height: 116,
      child: Form(
          key: _formKey,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonWidget.buildTextField(
              label: AppStrings.email, controller: _emailController, hint: 'you@company.com', validator: true, customValidator: (v) {
              if (v == null || v.isEmpty) {
              return AppStrings.required;
              }else if(!v.isValidEmail()){
              return AppStrings.enterValidEmailAddress;
              }
              return null; // ✅ valid input
              }),
          SizedBox(height: screenWidth * 0.03,),
          CommonWidget.buildTextField(label: AppStrings.password,
              controller: _passwordController, hint: AppStrings.enterPassword, validator: true, customValidator: (v){
            return v?.isValidPassword(v);
                // return null;
              },
              inputFormatters: [
                // LengthLimitingTextInputFormatter(8)
              ]
          ),
        ],
      )),
    );
  }

  Widget _buildRememberForgotRow({required BuildContext context, required double screenWidth, required double textScale}) {
    return SizedBox(
      width: screenWidth * 0.8,
      height: screenWidth * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer(builder: (key, ref, child){
            final checkStatus = ref.watch(_vm.checkApproved);
            return CircleCheckbox(
                value: checkStatus, onChanged: (v){
                  ref.refresh(_vm.checkApproved.notifier).state = v ?? false;
            });
          }),
          // SizedBox(width: screenWidth * 0.015,),
          MyTextStyles.getRegularText(
              text: ' ${AppStrings.rememberMe}', size:  12 + textScale , clr: Colors.grey),
          Spacer(),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return ForgotPassword();
              }));
            },
            child: Text(AppStrings.forgotPassword,
              style: TextStyle(
                  fontSize: 11.5 + textScale,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.2,
                  color: Colors.grey.shade400
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton({required WidgetRef ref, required double screenWidth, required double screenHeight}) {
    return Consumer(builder: (key, ref, child){
      final hasConnection = ref.watch(internetProvider).hasConnection;
      return AppButtons.buildContainerButton(
        text: AppStrings.logIn,
        height: screenHeight * 0.06,
        width: screenWidth * 0.8,
        onTap: () async {
          if(hasConnection){
            if(_formKey.currentState!.validate() && hasConnection){
            final body = {
              "username": _emailController.text,
              "password": _passwordController.text
            };
            // final body = {
            //   "username": "superadmin@dispatch.co.in",
            //   "password": "Dispatch@b34"
            // };
            final res = await _vm.onSignInAccount(loaderRef: ref, body: body);
            }
          }
        },
      );
    });
  }

  Widget _buildSignUpText({required BuildContext context, required double textScale}) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${AppStrings.dontHaveAnAccount}\n',
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.75),
            fontSize: 13 * textScale,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
          children: [
            MyTextStyles.getTextSpan(text: " ${AppStrings.letsCreateAnAccount}.", fontWeight: FontWeight.w500, textClr: AppColors.black, onTap: () {
              // DebugConfig.debugLog("Sign In tapped!");
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              //   return SignUpScreenNew();
              // }));
            }),
            MyTextStyles.getTextSpan(text: " ${AppStrings.signUp}", fontWeight: FontWeight.w600, size: 15, textClr: AppColors.mainClr, onTap: () {
              // DebugConfig.debugLog("Sign In tapped!");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return SignUpScreenNew();
              }));
            })
          ],
        ),
      ),
    );
  }

}
