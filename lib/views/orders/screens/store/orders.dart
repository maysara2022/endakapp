import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/views/orders/widgets/fixed_form.dart';
import 'package:endakapp/views/orders/widgets/order_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

class Orders extends StatefulWidget {
  const Orders({
    super.key,
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String? description;
  final String imageUrl;

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    setState(() {
      customFieldValues.clear();
      customFieldValues = {};
    });
    super.initState();
  }

  Key formKey = UniqueKey();

  final OrdersController _ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.screenHeight * .05,
              ),
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(
                        widget.imageUrl,
                        width: AppSize.screenWidth / 2,
                        height: AppSize.screenHeight / 6,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Text(
                    widget.description ?? '..',
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
                  ),
                ],
              ),
            ),
            AppSize.box(.01, 0),
            FixedForm(categoryId: widget.id),
            FutureBuilder(
              future: _ordersController.fetchFormFields(
                subCategoryId: widget.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                }
                final forms = snapshot.data ?? [];
                if (forms.isEmpty) {
                  return const Center(child: SizedBox());
                }
                return OrderForm(key: formKey, fields: forms);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.screenHeight * .02,
              ),
              child: SizedBox(
                width: AppSize.screenWidth,
                child: ElevatedButton(
                  onPressed: () async {
                    await _ordersController.submitCustomFields(
                      widget.id,
                      widget.title,
                      descriptionController.text.trim(),
                      _ordersController.selectedCity.value?.id.toString() ?? '',
                      widget.imageUrl,
                      widget.title,
                      customFieldValues,
                    );
                    setState(() {
                      customFieldValues.clear();
                      customFieldValues = {};
                      descriptionController.clear();
                      formKey = UniqueKey();
                    });
                  },
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.primaryColor,
                    ),
                  ),
                  child: Text(
                    'إرسال',
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              ),
            ),

            AppSize.box(.08, 0),
          ],
        ),
      ),
    );
  }
}
