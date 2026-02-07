import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSize.screenWidth*.02),
            child: Container(
              padding: EdgeInsets.all(AppSize.screenWidth*.03),
              decoration:BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
              ) ,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.amber.shade100,
                    child: Icon(Iconsax.notification,color: AppColors.secondaryColor),
                  ),
                  AppSize.box(0, .03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text('عرض جديد لخدمتك',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                      Text('عرض يد لخدمتك'),
                    ],),

                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    Row(
                      children: [
                        Icon(Iconsax.clock,color:AppColors.secondaryColor,size: 15,),
                        Text(' منذ يوم',),

                      ],
                    ),
                    AppSize.box(.03, 0),

                    IconButton(onPressed: (){}, icon: Icon(Iconsax.trash,color: Colors.red,)),

                  ],)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
