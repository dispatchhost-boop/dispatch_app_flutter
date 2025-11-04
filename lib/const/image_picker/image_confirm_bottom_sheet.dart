import 'dart:io';
import 'package:dispatch/const/app_colors.dart';
import 'package:dispatch/const/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';

class ConfirmationImageBottomSheet {
  static void showBottomSheet({
    required BuildContext context,
    required File selectedImage,
    required bool status,
    required VoidCallback onConfirm,
  }) {

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Required for blur
      barrierColor: Colors.black.withOpacity(0.3), // Optional: semi-darken background
      elevation: 0,
      builder: (_) => _BlurredSheetContent(
        selectedImage: selectedImage,
        status: status,
        onConfirm: onConfirm,
      ),
    );
  }
}

class _BlurredSheetContent extends StatelessWidget {
  final File selectedImage;
  final bool status;
  final VoidCallback onConfirm;

  const _BlurredSheetContent({
    required this.selectedImage,
    required this.status,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    return Stack(
      children: [
        // Blur background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(color: Colors.transparent),
        ),

        // Bottom sheet aligned to bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012, horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppStrings.areYouSureYouWantToUpdateTheImage,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16 * textScale,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(selectedImage,
                        fit: BoxFit.fitWidth,
                        cacheHeight: 800,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  SizedBox(height: screenHeight * 0.016),
                  Row(
                    children: [
                      Expanded(
                        child: _ConfirmationButton(
                          text: AppStrings.cancel,
                          status: status,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      // const SizedBox(width: 12),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: _ConfirmationButton(
                          text: AppStrings.yes,
                          status: status,
                          onTap: () {
                            onConfirm();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _ConfirmationButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool status;

  const _ConfirmationButton({
    required this.text,
    required this.onTap,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final textScale = media.textScaleFactor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
        decoration: BoxDecoration(
          color: AppColors.mainClr,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16* textScale,
            ),
          ),
        ),
      ),
    );
  }
}