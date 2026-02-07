import 'package:endakapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyType;
  final TextEditingController controller;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.label,
    this.keyType,
    required this.controller,
    this.icon, this.maxLines, this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines:minLines,
      maxLines:maxLines,
      keyboardType: keyType,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: AppColors.greyColor),
        label: Text(label),
        filled: true,
        fillColor: AppColors.whiteColor,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
