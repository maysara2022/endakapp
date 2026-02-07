import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/cities/cities.dart';
import 'package:endakapp/views/orders/widgets/custom_drop_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCitiesMenu extends StatefulWidget {
  final Function(CityModel) onSelected;

  const AllCitiesMenu({super.key, required this.onSelected});


  @override
  State<AllCitiesMenu> createState() => _AllCitiesMenuState();
}

class _AllCitiesMenuState extends State<AllCitiesMenu> {
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
    cities = await _orderController.getAllCities();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return  CustomDropMenu(options: [],label: 'المدينة',);
    }if(cities.isEmpty){
      return  CustomDropMenu(options: [],label: 'المدينة',);

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
        items: cities.map((city) {
          return DropdownMenuItem<String>(

            value: city.nameAr,
            child: Text(
              city.nameAr,
              style: GoogleFonts.cairo(),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            selected = cities.firstWhere((c) => c.nameAr == value);
          });
          widget.onSelected(selected!);
        },


      ),
    );
  }

}
