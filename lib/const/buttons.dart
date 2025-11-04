import 'package:dispatch/const/app_colors.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:flutter/material.dart';

class AppButtons{
  static SizedBox textButton({
    required String text, double height = 54, double width = 110,
    required void Function()? onPressed, double fontSize = 15,
    Color foregroundClr = Colors.white, Color textClr = Colors.black,
    FontWeight fontWeight = FontWeight.w600, double borderWidth = 0,
    ButtonStyle? buttonStyle}){
    return SizedBox(
      // height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        style: buttonStyle ?? TextButton.styleFrom(
          minimumSize: Size(double.infinity, height),
          foregroundColor: foregroundClr,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: borderWidth, color: AppColors.mainClr)
          ),
        ),
        child: Text(text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 0.5,
            color: textClr
          ),
        ),
      ),
    );
  }

  static SizedBox elevatedButton({
    required String text, double height = 54, double width = 110,
    required void Function()? onPressed, double fontSize = 15,
    Color? backgroundColor, FontWeight fontWeight = FontWeight.w600,
    ButtonStyle? buttonStyle}){
    return SizedBox(
      // height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle ?? ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.mainClr,
          minimumSize: Size(double.infinity, height),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  static Widget buildContainerButton({double height = 40, double width = double.infinity, Color txtClr = AppColors.white, Color boxClr = AppColors.mainClr, required String text, void Function()? onTap, double size = 18}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: boxClr, // button-like background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: MyTextStyles.getRegularText(text: text, clr: txtClr, size: size),
        ),
      ),
    );
  }

}