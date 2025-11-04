import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import 'loader_controller.dart';

class Loader extends ConsumerWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = MediaQuery.of(context);
  final screenHeight = kIsWeb ? 800.0 : media.size.height;
  final screenWidth = kIsWeb ? 400.0 : media.size.width;
  // final textScale = media.textScaleFactor;
  bool isBigSize = screenWidth >= 550;
    final isLoading = ref.watch(loadingProvider);

    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return PopScope(
      canPop: false, // This disables the back button
      child: Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.2),
          ),
          Center(
            child: Container(
              height: screenHeight * 0.085,
              width: isBigSize ? screenWidth * 0.2 : screenWidth * 0.25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.mainClr, backgroundColor: AppColors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
