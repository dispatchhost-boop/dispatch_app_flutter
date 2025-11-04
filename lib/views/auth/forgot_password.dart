import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const/app_strings.dart';
import '../../const/buttons.dart';
import '../../const/common_widget.dart';
import '../../const/text_style.dart';
import '../../const/app_colors.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/loader/loader_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, loader, _) {
        final isLoading = loader.watch(loadingProvider);

        return PopScope(
          canPop: isLoading ? false : true,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  backgroundColor: AppColors.white,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: MyTextStyles.getSemiBoldText(
                    text: AppStrings.forgotPassword,
                    size: 20,
                  ),
                ),

                body: Center(
                child: SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const SizedBox(height: 70),
                      MyTextStyles.getRegularText(text: AppStrings.enterYourEmailAndWillSendYouInstructionOnHowToResetIt, size: 16),
                      const SizedBox(height: 40,),
                      _buildTextField(),
                      const SizedBox(height: 25),
                      _buildSendButton(loader),
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
  Widget _buildTextField(){
    return CommonWidget.buildTextField(controller: _emailController, hint: AppStrings.email);
  }

  Widget _buildSendButton(WidgetRef ref) {
    return AppButtons.buildContainerButton(
      text: AppStrings.send,
      height: 50,
      width: 320,
      onTap: () {
        ref.read(loadingProvider.notifier).state = true;

        Future.delayed(const Duration(seconds: 8), () {
          ref.read(loadingProvider.notifier).state = false;
        });
      },
    );
  }

}
