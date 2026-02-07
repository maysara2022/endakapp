import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/views/home/widgets/services_categories.dart';
import 'package:flutter/material.dart';

class StoreOrderScreen extends StatelessWidget {
  const StoreOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSize.box(.05, 1),
          Text('الأقسام الرئيسية',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 27),),
          AppSize.box(.009, 1),
          Text('اختر من بين مجموعة واسعة من الأقسام',style: TextStyle(fontSize: 19)),
          AppSize.box(.02, 1),
          Expanded(
            child: ServicesCategories(),
          ),
        ],
      ),
    );
  }
}
