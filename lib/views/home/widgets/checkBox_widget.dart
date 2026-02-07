import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/forms/form_model.dart';
import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final FormModel field;
  final bool checked;
  final Function(bool?)? onChanged;

  const CheckboxWidget({
    super.key,
    required this.checked,
    required this.field,
    this.onChanged,
  });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CheckboxListTile(
        value: checked,
        title: Text(
          widget.field.nameAr,
          style: TextStyle(color: AppColors.blackColor),
          textAlign: TextAlign.right,
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: EdgeInsets.symmetric(horizontal: 4),
        onChanged: (value) {
          setState(() {
            checked = value ?? false;
            if (widget.onChanged != null) widget.onChanged!(checked);
          });
        },
      ),
    );
  }
}
