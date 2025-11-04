import 'dart:io';
import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/buttons.dart';
import 'package:flutter/material.dart';

void showImagePreviewDialog({
  required BuildContext context,
  required String imagePath,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final isBig = screenWidth >= 550;//height: 55,

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                bottom: screenHeight * 0.1,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.6,
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.03,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: AppButtons.elevatedButton(
                  height: isBig ? 55 : 42,
                  width: screenWidth * 0.3,
                  text: AppStrings.back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

