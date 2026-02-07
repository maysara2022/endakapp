import 'package:endakapp/controllers/categories/categories_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/services/services_categories.dart';
import 'package:endakapp/views/orders/widgets/custom_drop_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class  AllCategories extends StatefulWidget {
  final Function(ServicesCategories) onSelected;
  const AllCategories({super.key, required this.onSelected});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

CategoriesController _controller = CategoriesController();


class _AllCategoriesState extends State<AllCategories> {
  ServicesCategories? selectedCategory;

  bool isLoading = true;

  List<ServicesCategories> categories = [];

  Future<void> loadCategories() async {
    categories = await _controller.fetchCategories();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
      CustomDropMenu(options: [],label: 'التصنيف',)

    :
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryColor),
          color: Colors.white,
        ),
        child: DropdownButton<ServicesCategories>(
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(
            'التصنيف',
            style: GoogleFonts.cairo(),
          ),
          value: selectedCategory,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: categories.map((category) {
            return DropdownMenuItem<ServicesCategories>(
              value: category,
              child: Text(
                category.name ?? '',
                style: GoogleFonts.cairo(),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
            widget.onSelected(value!);
          },

        ),
      );

  }
}
