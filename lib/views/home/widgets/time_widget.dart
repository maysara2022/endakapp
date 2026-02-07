import 'package:endakapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeWidget extends StatefulWidget {
  const TimeWidget({
    super.key,
    required this.controller,
    this.keyType,
    this.icon,
  });

  final TextEditingController controller;
  final TextInputType? keyType;
  final IconData? icon;

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: widget.controller,
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final formattedTime = pickedTime.format(Get.context!);
          widget.controller.text = formattedTime;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Icon(widget.icon, color: AppColors.greyColor),
        label: Text('الوقت'),
        filled: true,
        fillColor: AppColors.whiteColor,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
