import 'package:endakapp/controllers/categories/categories_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/widgets/connection_faild.dart';
import 'package:endakapp/views/orders/screens/store/orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategories extends StatefulWidget {
  final String slug;

  const SubCategories({
    super.key,
    required this.slug,
    required this.id,

  });

  final String id;

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final CategoriesController _categoriesController = Get.put(
    CategoriesController(),
  );

  final imageUrl = '${EndPoints.web}${EndPoints.storage}';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoriesController.fetchSubCategories(widget.slug),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ConnectionFailed(fun : (){setState(() {
          });});
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
                  Get.to(
                    Orders(
                      id: widget.id,
                      title: categories.elementAt(index).nameAr??'',
                      description: categories.elementAt(index).descriptionAr??'',
                      imageUrl: imageUrl + categories.elementAt(index).image!,
                    ),
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
                              categories.elementAt(index).nameAr ?? '',
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
}
