import 'package:endakapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({
    super.key,
    required this.controller,
    this.keyType,
    this.icon,
  });

  final TextEditingController controller;
  final TextInputType? keyType;
  final IconData? icon;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: widget.controller,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          widget.controller.text =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        }
      },
      decoration: InputDecoration(
        suffixIcon: Icon(widget.icon, color: AppColors.greyColor),
        label: Text('التاريخ'),
        filled: true,
        fillColor: AppColors.whiteColor,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
