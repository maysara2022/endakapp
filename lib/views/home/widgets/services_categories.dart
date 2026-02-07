import 'package:endakapp/controllers/categories/categories_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/widgets/connection_faild.dart';
import 'package:endakapp/views/orders/screens/store/orders.dart';
import 'package:endakapp/views/home/screens/sub_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesCategories extends StatefulWidget {
  ServicesCategories({super.key});

  @override
  State<ServicesCategories> createState() => _ServicesCategoriesState();
}

class _ServicesCategoriesState extends State<ServicesCategories> {
  final CategoriesController _categoriesController = Get.put(
    CategoriesController(),
  );

  final imageUrl = '${EndPoints.web}${EndPoints.storage}';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoriesController.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ConnectionFailed(
            fun: () {
              setState(() {
              });
            },
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد بيانات'));
        } else {
          final categories = snapshot.data!;
          return GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  onCategorySelected(
                    categories.elementAt(index).slug ?? '',
                    categories.elementAt(index).name ?? '',
                    categories.elementAt(index).description ?? '',
                    categories.elementAt(index).id.toString(),
                    imageUrl + categories.elementAt(index).image! ?? '',
                  );
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            imageUrl + categories.elementAt(index).image!,
                            width: double.infinity,
                            height: AppSize.screenHeight / 5,
                            fit: BoxFit.cover,
                          ),

                          Container(
                            width: double.infinity,
                            color: Colors.black38,
                          ),

                          Center(
                            child: Text(
                              categories.elementAt(index).name ?? '',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void onCategorySelected(
    String slug,
    String name,
    String description,
    String id,
    String imageUrl,
  ) async {
    final subCategories = await _categoriesController.fetchSubCategories(slug);

    if (subCategories.isEmpty) {
      Get.to(
        Orders(
          id: id,
          title: name,
          description: description,
          imageUrl: imageUrl,
        ),
      );
    } else {
      Get.to(
        SubScreen(
          slug: slug,
          name: name,
          description: description,
          id: id,
          imageUrl: imageUrl,
        ),
      );
    }
  }
}
