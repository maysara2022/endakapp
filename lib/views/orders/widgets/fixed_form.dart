import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/models/cities/cities.dart';
import 'package:endakapp/views/home/widgets/record_widget.dart';
import 'package:endakapp/views/orders/widgets/cities_menu.dart';
import 'package:endakapp/views/register/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FixedForm extends StatefulWidget {
  const FixedForm({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<FixedForm> createState() => _FixedFormState();
}
OrdersController _orderController = Get.put(OrdersController());

bool isRecording = false;
List<CityModel> cities = [];
CityModel? selectedCity;

Future<void> loadCities(String cityId) async {
  cities = await _orderController.getCities(cityId);
}
TextEditingController descriptionController = TextEditingController();

class _FixedFormState extends State<FixedForm> {
  @override
  void initState() {
    super.initState();
    loadCities(widget.categoryId);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            VoiceRecordField(
              isRecording: isRecording,
              onRecord: () {
                setState(() => isRecording = true);
              },
              onStop: () {
                setState(() => isRecording = false);
              },
            ),

          TextField(
            keyboardType: TextInputType.multiline,
            controller: descriptionController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText:'التفاصيل',
              alignLabelWithHint: true,
              labelStyle: TextStyle(color: AppColors.greyColor),
              filled: true,
              fillColor: AppColors.whiteColor,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          CitiesMenu(categoryId: widget.categoryId)
        
        ],),
      ),
    );
  }

}
