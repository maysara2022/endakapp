import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/views/orders/screens/view/view_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
class OrderCard extends StatelessWidget {
  final int orderId;
  final String? imageUrl;
  final String? title;
  final String? metaTitle;
  final String? description;
  final double? price;
  final String? category;
  final bool status;
  final Map <String, dynamic>? customField;

  const OrderCard({
    super.key,
   this.imageUrl,
   this.title,
   this.description,
   this.price,
   this.category,
   required this.status,
   this.customField,
   this.metaTitle,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(AppSize.screenWidth * .02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl??'https://endak.net/storage/categories/dHra9gyb23VWle3fZXF6wgdEBTiFhWeY5MThzCrk.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title??'',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              description??'',
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  '$price ريال',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  status ? 'متاحة':'غير متاحة',
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 17,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Get.to(
                    ViewOrderScreen(
                   orderId: orderId,
                  status: status,
                  imageUrl: imageUrl,
                  title: title,
                  description: description,
                  price: price,
                  category: category,
                  customField: customField,
                  metaTitle: metaTitle??title,

                ));
              },
              style: ButtonStyle(
                backgroundColor:
                WidgetStateProperty.all(AppColors.whiteColor),
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.eye),
                  Text(
                    '  عرض التفاصيل',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 19,
                    ),
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
