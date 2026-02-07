import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:flutter/material.dart';

import '../widgets/sub_categories.dart' show SubCategories;

class SubScreen extends StatelessWidget {
  SubScreen({super.key, required this.id,required this.name, required this.description, required this.imageUrl, this.slug});

  final String? slug;
  final String? name;
  final String? description;
  final String id ;
  final String imageUrl;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقسام الفرعية'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSize.screenWidth*.02),
            width: AppSize.screenWidth,
            height: AppSize.screenHeight/3,
            decoration:BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name??'',style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),
                Text(description??'',textAlign: TextAlign.center,style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),)
              ],
            )
          ),
          Expanded(child: SubCategories(slug: slug??'', id: id))

        ],
      ),
    );
  }
}
