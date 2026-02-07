import 'package:endakapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomDropMenu extends StatefulWidget {
  CustomDropMenu({
    super.key,
    required this.options,
    required this.label,
    this.fun,
  });

  List<dynamic> options;
  String label;
  void Function(String?)? fun;

  @override
  State<CustomDropMenu> createState() => _CustomDropMenuState();
}

class _CustomDropMenuState extends State<CustomDropMenu> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(widget.label, style: GoogleFonts.cairo()),
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: widget.options.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: GoogleFonts.cairo()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          if (widget.fun != null) {
            widget.fun!(value);
          }
        },
      ),
    );
  }
}
