import 'dart:io';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_strings.dart';
import 'image_preview.dart';
import '../text_style.dart';

Widget onImagePickView({String? imagePath, bool? isRequired, required BuildContext context, required void Function() onMainBoxTap, required void Function()? onRemovePressed}){
  return Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Row(
    children: [
      MyTextStyles.getRegularText(text: 'Photo :'),
      const Spacer(),
      Column(
        children: [
          GestureDetector(
            onTap: onMainBoxTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 110,
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey.shade300
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      File(imagePath),
                      width: 90,
                      height: 115,
                      fit: BoxFit.fill,
                      cacheWidth: 90,
                      cacheHeight: 115,
                    ),
                  )
                      : const Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 40,
                    ),
                  ),
                ),
                if (imagePath != null)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: Colors.red, // Use your color variable here
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: IconButton(
                        onPressed: onRemovePressed,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        padding: const EdgeInsets.all(0),
                        // constraints: BoxConstraints(), // optional if you want smaller icon
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if(imagePath != null)
            TextButton(onPressed: (){
              showImagePreviewDialog(
                  context: context,
                  imagePath: imagePath ?? '');
            }, child: MyTextStyles.getRegularText(text: AppStrings.view, clr: AppColors.mainClr)),
          if(isRequired == true)
            Column(
              children: [
                const SizedBox(height: 4),
                MyTextStyles.getRegularText(text: AppStrings.required, size: 12, clr: Colors.red),
              ],
            )
        ],
      ),
    ],
  ),);
}