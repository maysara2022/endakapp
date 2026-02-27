import 'package:endakapp/controllers/categories/categories_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/models/cities/cities.dart';
import 'package:endakapp/models/services/sub_category.dart';
import 'package:endakapp/views/orders/screens/view/filtered_orders.dart';
import 'package:endakapp/views/orders/widgets/all_categorys.dart';
import 'package:endakapp/views/orders/widgets/all_cities.dart';
import 'package:endakapp/views/orders/widgets/all_subs.dart';
import 'package:endakapp/views/orders/widgets/orders_list.dart';
import 'package:endakapp/views/register/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

CategoriesController _controller = Get.put(CategoriesController());
TextEditingController _searchController = TextEditingController();


class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int? selectedValue;
  int? category;
  int? city;
  int? sub;
  String? catSlug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: AppSize.screenWidth,
              height: AppSize.screenHeight / 3,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(),
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    'خدماتي المطلوبة',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'تابع خدماتك المطلوبة وتفاصيلها بسهولة واحترافية.',
                    style: TextStyle(fontSize: 20, color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 17,
                children: [
                  AppSize.box(.05, 0),
                  CustomTextField(label: 'ابحث في خدماتك', controller: _searchController,),

                  // TextField(
                  //   decoration: InputDecoration(
                  //     fillColor: AppColors.whiteColor,
                  //     label: Text('ابحث في خدمات...'),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(40),
                  //       borderSide: BorderSide(color: AppColors.primaryColor),
                  //     ),
                  //     disabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(40),
                  //       borderSide: BorderSide(color: AppColors.greyColor),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(40),
                  //       borderSide: BorderSide(color: AppColors.primaryColor),
                  //     ),
                  //   ),
                  // ),
                  AllCategories(
                    onSelected: (value) {
                      setState(() {
                        category = value.id;
                        catSlug = value.slug;
                        sub = null;
                        _controller.fetchSubCategories(catSlug!);
                      });
                    },
                  ),
                  AllSubs(
                    slug: catSlug,
                    onSelected: (SubCategories p1) {
                      setState(() {
                        sub = p1.id;
                      });
                    },
                  ),

                  AllCitiesMenu(
                    onSelected: (CityModel p1) {
                      city = p1.id;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(FilteredOrders(category: category,city:city,searchTerm: _searchController.text,subCategory: sub));
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.secondaryColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.search_normal_copy,
                          color: AppColors.whiteColor,
                        ),
                        Text(
                          '  بحث',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSize.box(.03, 0),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppSize.screenWidth * .01),
              decoration: BoxDecoration(color: Colors.blue.shade100),
              child: Column(
                children: [
                  AppSize.box(.02, 0),
                  Text(
                    'خدماتي',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: AppColors.secondaryColor,
                    thickness: 3,
                    endIndent: AppSize.screenWidth / 2.7,
                    indent: AppSize.screenWidth / 2.7,
                    radius: BorderRadius.all(Radius.circular(15)),
                  ),
                  AppSize.box(.02, 0),
                  SizedBox(
                    height: AppSize.screenHeight / 2,
                    child: OrdersList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
