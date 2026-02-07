import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/cities/cities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CitiesMenu extends StatefulWidget {
  const CitiesMenu({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<CitiesMenu> createState() => _CitiesMenuState();
}

class _CitiesMenuState extends State<CitiesMenu> {
  final OrdersController _orderController = Get.put(OrdersController());

  List<CityModel> cities = [];
  CityModel? selected;
  String? selectedValue;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    cities = await _orderController.getCities(widget.categoryId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

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
        hint: Text(
          'المدينة',
          style: GoogleFonts.cairo(),
        ),
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: cities.map((item) {
          return DropdownMenuItem<String>(
            value: item.nameAr,
            child: Text(
              item.nameAr,
              style: GoogleFonts.cairo(),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            CityModel selected = cities.firstWhere((e) => e.nameAr == value);
            _orderController.setSelectedCity(selected);
          });

        },
      ),
    );
  }
}
