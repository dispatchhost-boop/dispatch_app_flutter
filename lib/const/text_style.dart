import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class MyTextStyles{

  static Text getRegularText({required String text, Color clr = AppColors.black, double size = 15, TextOverflow overFlow = TextOverflow.visible, int? maxLines}){
    return Text(text, style: TextStyle(color: clr, fontSize: size, fontWeight: FontWeight.normal, fontFamily: 'Poppins',), overflow: overFlow, maxLines: maxLines,);
  }

  static Text getSemiBoldText({required String text, Color clr = AppColors.black, double size = 15, TextOverflow? overFlow, int? maxLines}){
    return Text(text, style: TextStyle(color: clr, fontSize: size, fontWeight: FontWeight.w600, fontFamily: 'Poppins',), overflow: overFlow, maxLines: maxLines);
  }

  static Text getBoldText({required String text, Color clr = AppColors.black, double size = 15, TextOverflow? overFlow, int? maxLines}){
    return Text(text, style: TextStyle(color: clr, fontSize: size, fontWeight: FontWeight.w800, fontFamily: 'Poppins',), overflow: overFlow, maxLines: maxLines);
  }

  static TextSpan getTextSpan({required String text, required FontWeight fontWeight, Color textClr = Colors.black, void Function()? onTap, TextDecoration? decoration, double? size}){
    return TextSpan(
      text: text,
      style: TextStyle(
        color: textClr,
        fontSize: size,
        fontWeight: fontWeight,
        decorationColor: AppColors.mainClr,
        fontFamily: 'Poppins',
        overflow: TextOverflow.ellipsis,
        decoration: decoration
      ),
        recognizer: TapGestureRecognizer()
          ..onTap = onTap
    );
  }

}