import 'package:endakapp/models/forms/form_model.dart';
import 'package:endakapp/views/home/widgets/checkBox_widget.dart';
import 'package:endakapp/views/home/widgets/date_widget.dart';
import 'package:endakapp/views/home/widgets/image_widget.dart';
import 'package:endakapp/views/home/widgets/time_widget.dart';
import 'package:endakapp/views/orders/widgets/custom_drop_menu.dart';
import 'package:endakapp/views/register/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key, required this.fields});

  final List<FormModel> fields;

  @override
  State<OrderForm> createState() => _OrderFormState();
}

Map<String, dynamic> customFieldValues = {};

class _OrderFormState extends State<OrderForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 10,
          children: widget.fields.map((field) {
            return Column(spacing: 10, children: [buildField(field)]);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildField(FormModel field) {
    print('🔑 Field nameEn: "${field.nameEn}"');

    switch (field.type) {
      case 'text':
      case 'textarea':
        final controller = TextEditingController(
          text: field.value?.toString() ?? '',
        );
        controller.addListener(() {
          customFieldValues[field.nameEn] = controller.text;
        });
        return CustomTextField(label: field.nameAr, controller: controller);

      case 'number':
        final controller = TextEditingController(
          text: field.value?.toString() ?? '',
        );
        controller.addListener(() {
          customFieldValues[field.nameEn] = controller.text;
        });
        return CustomTextField(label: field.nameAr, controller: controller,keyType: TextInputType.number,);

      case 'checkbox':
        return CheckboxWidget(
          field: field,
          checked: field.value == true,
          onChanged: (value) {
            customFieldValues[field.nameEn] = value;
          },
        );

      case 'select':
        List options = field.options ?? [];
        return CustomDropMenu(
          options: options,
          label: field.nameAr,
          fun: (value) {
            value = value ?? '';
            customFieldValues[field.nameEn] = value;
          },
        );

      case 'date':
        final controller = TextEditingController(
          text: field.value?.toString() ?? '',
        );
        controller.addListener(() {
          customFieldValues[field.nameEn] = controller.text;
        });
        return DateWidget(controller: controller);

      case 'time':
        final controller = TextEditingController(
          text: field.value?.toString() ?? '',
        );
        controller.addListener(() {
          customFieldValues[field.nameEn] = controller.text;
        });
        return TimeWidget(controller: controller);

      case 'image':
        return ImagePickerWidget(
          label: field.nameAr,
          fieldKey: field.nameEn,
          onImageSelected: (XFile? image) {
            setState(() {
              if (image != null) {
                customFieldValues[field.nameEn] = image;
              } else {
                customFieldValues.remove(field.nameEn);
              }
            });
          },
          selectedImage: customFieldValues[field.nameEn] as XFile?,
        );

      default:
        return SizedBox();
    }
  }
}
