import 'package:endakapp/controllers/categories/categories_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/services/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_drop_menu.dart';
class AllSubs extends StatefulWidget {
  final String? slug;
  final Function(SubCategories) onSelected;
   const AllSubs({super.key, this.slug, required this.onSelected});

  @override
  State<AllSubs> createState() => _AllSubsState();
}

class _AllSubsState extends State<AllSubs> {
  final CategoriesController _controller = CategoriesController();

  SubCategories? selectedSub;
  List<SubCategories> subCategories = [];
  bool isLoadingSub = true;

  @override
  void didUpdateWidget(covariant AllSubs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug && widget.slug != null) {
      loadSubCategories(widget.slug!);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.slug != null && widget.slug!.isNotEmpty) {
      loadSubCategories(widget.slug!);
    } else {
      isLoadingSub = false;
    }
  }

  Future<void> loadSubCategories(String slug) async {
    try {
      subCategories = [];
      selectedSub = null;
      setState(() => isLoadingSub = true);
      subCategories = await _controller.fetchSubCategories(slug);
    } catch (e) {
      subCategories = [];
    } finally {
      setState(() => isLoadingSub = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingSub) {
     return  CustomDropMenu(options: [],label: 'الأقسام الفرعية',);
    }
    if (subCategories.isEmpty) {
      return  CustomDropMenu(options: [],label: 'الأقسام الفرعية',);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor),
        color: Colors.white,
      ),
      child: DropdownButton<SubCategories>(
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(
          'الأقسام الفرعية',
          style: GoogleFonts.cairo(),
        ),
        value: selectedSub,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: subCategories.map((sub) {
          return DropdownMenuItem<SubCategories>(
            value: sub,
            child: Text(
              sub.nameAr ?? '',
              style: GoogleFonts.cairo(),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedSub = value;
          });
        },
      ),
    );
  }
}
