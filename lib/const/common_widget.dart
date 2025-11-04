import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class CommonWidget{

  static Widget buildDropDown<T>({
    String? label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String hint,
    required double fontSize,
    bool? validator,
    String? Function(T?)? customValidator,
    required T? value,
    String Function(T)? displayItem,
    bool removeSpace = false,
    Color? fillClr,
    double? maxWidth,
    double? maxHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label.replaceAll('*', ''),
                  style: const TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'Poppins',),
                ),
                if (label.contains('*'))
                  const TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontFamily: 'Poppins',),
                  ),
              ],
            ),
          ),
        if (label != null) const SizedBox(height: 5),
        ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? double.infinity, // 👈 set your max width
            ),
            child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<T>(
            value: value,
            isExpanded: true,
            menuMaxHeight: maxHeight ?? 300,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillClr ?? Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
              ),
              errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
              ),
              disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
              ),
              focusedErrorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
              ),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                // borderSide: BorderSide(color: AppColors.mainClr, width: 1.5),
              ),
              // ... rest as you had
            ),
            hint: Text(hint, style: TextStyle(fontSize: fontSize, fontFamily: 'Poppins',)),
            items: items
                .map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayItem != null ? displayItem(item) : item.toString(),
                maxLines: 2,
                style: TextStyle(fontSize: fontSize, fontFamily: 'Poppins',),
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            onChanged: onChanged,
            // validator: validator,
            validator: validator == true
                ? customValidator ??
                    (T? v) {
                  if (v == null) {
                    return AppStrings.required;
                  }
                  else if (v is String && (v.isEmpty || v.trim().isEmpty)) {
                    return AppStrings.required;
                  }
                  return null;
                }
                : null,

          ),
        )),
      ],
    );
  }

  static Widget buildTextField({
    String? label,
    required TextEditingController controller,
    bool enabled = true,
    bool readOnly = false,
    required String hint,
    bool? validator,
    FormFieldValidator<String>? customValidator,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    void Function()? onTap,
    Widget? suffixIcon,
    Color? suffixIconClr,
    Widget? prefixIcon,
    Color? preFixClr,
    Color? cursorColor,
    bool removeSpace = false,
    Color? fillClr,
    Color labelClr = Colors.black,
    FontWeight? labelFontWeight,
    FocusNode? focusNode,
    Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              children: label.split('*').map((textPart) {
                if (textPart.isEmpty) {
                  return TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontFamily: 'Poppins', fontWeight: labelFontWeight),
                  );
                }
                return TextSpan(
                  text: textPart,
                  style: TextStyle(fontSize: 14, color: labelClr, fontFamily: 'Poppins', fontWeight: labelFontWeight),
                );
              }).toList(),
            ),
          ),
        if (label != null) const SizedBox(height: 5),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          // enableInteractiveSelection: false,
          // magnifierConfiguration: TextMagnifierConfiguration.disabled,
          validator: validator == true ? customValidator ?? commonValidator : null,
          maxLines: maxLines,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          readOnly: readOnly,
          cursorColor: cursorColor ?? AppColors.mainClr,
          decoration: InputDecoration(
            filled: true,
            errorMaxLines: 5,
            fillColor: fillClr ?? Colors.grey.shade100,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins',),
            suffixIcon: suffixIcon,
            suffixIconColor: suffixIconClr,
            prefixIcon: prefixIcon,
            prefixIconColor: preFixClr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
            ),
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
            ),
            disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
            ),
          ),
        ),
      ],
    );
  }

  static FormFieldValidator<String>? commonValidator = (v) {
    if (v == null || v.isEmpty) {
      return AppStrings.required;
    }
    return null; // ✅ valid input
  };



}