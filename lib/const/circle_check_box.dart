
import 'package:flutter/material.dart';

import 'app_colors.dart';

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CircleCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 22, // outer circle size
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: value ? AppColors.mainClr : Colors.black45, width: 2),
          color: value ? AppColors.mainClr : Colors.transparent,
        ),
        child: value
            ? Center(
          child: Icon(
            Icons.check,
            size: 18, // ✅ smaller check icon
            color: Colors.white,
          ),
        )
            : null,
      ),
    );
  }
}
