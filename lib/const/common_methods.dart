import 'package:dispatch/const/response_dialog.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';
import 'app_strings.dart';

class CommonMethods{

  static showErrorDialog({required String msg, VoidCallback? onPressed1}){
    Get.dialog(
      ResponseDialog(
        title: AppStrings.error,
        msg: msg,
        buttonText: AppStrings.ok,
        popTimes: 1,
        dlgClr: AppColors.mainClr,
        onPressed1: onPressed1 ?? () {
          Get.back(); // Cancel button action
        },
      ),
      barrierDismissible: false,
    );
    return null;
  }

  static showSnackBar({required String title, required String message}){
    return Get.snackbar(
      title, // title
      message, // message
      snackPosition: SnackPosition.TOP, // show at top
      backgroundColor: AppColors.mainClr,
      colorText: AppColors.white,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static PreferredSizeWidget onAppBar({required String text}){
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Get.back();
        },
      ),
      title: MyTextStyles.getSemiBoldText(
        text: text,
        size: 20,
      ),
    );
  }

  static Widget getRowText(
      {String? heading,
        String? subHeading,
        int? style,
        double? headingSize,
        double? subHeadingSize,
        TextOverflow? overFlow,
        Color headingClr = Colors.black,
        Color subHeadingClr = Colors.black}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(style == 2)
        MyTextStyles.getSemiBoldText(text: heading ?? '', overFlow: overFlow, clr: headingClr, size: headingSize ?? 15),
        if(style == null)
          MyTextStyles.getRegularText(text: heading ?? '', overFlow: overFlow ?? TextOverflow.ellipsis, clr: headingClr, size: headingSize ?? 15),
        Expanded(child: MyTextStyles.getRegularText(text: subHeading ?? '', overFlow: overFlow ?? TextOverflow.ellipsis, clr: subHeadingClr, size: subHeadingSize ?? 15))
      ],
    );
  }

  static String getPercentageChange({required num initialValue, required num finalValue}) {
    if (initialValue == 0) {
      if (finalValue == 0) return "0.00 %";
      return finalValue > 0
          ? "+100.00 %"
          : "-${finalValue.toStringAsFixed(2)} %";
    }

    final change = finalValue - initialValue;
    final percentChange = (change / initialValue.abs()) * 100;


    final sign = percentChange >= 0 ? '+' : '-';
    return "$sign${percentChange.abs().toStringAsFixed(2)} %";
  }

  static String getSymbol(String value){
    if(value.contains('-')){
      return '▼';
    }else{
      return '▲';
    }
  }
  /// Converts a date string from one format to another.
  /// Example: formatDate("06/08/2025", fromFormat: "dd/MM/yyyy", toFormat: "yyyy-MM-dd")
  /// only for "dd/MM/yyyy" to "yyyy-MM-dd"
  static String formatDateForRequest({required String date}) {
    try {
      final inputFormat = DateFormat("dd/MM/yyyy");
      final outputFormat = DateFormat("yyyy-MM-dd");
      final parsedDate = inputFormat.parse(date);
      return outputFormat.format(parsedDate);
    } catch (e) {
      return date; // return original if parsing fails
    }
  }


}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}