import 'package:endakapp/controllers/notifications/notifications_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/views/home/widgets/services_categories.dart';
import 'package:endakapp/views/notification/screens/notification_screen.dart';
import 'package:endakapp/views/orders/screens/store/store_order_screen.dart';
import 'package:endakapp/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
final NotificationsController _notificationsController = Get.put(NotificationsController());

class _HomeScreenState extends State<HomeScreen> {
   final ScrollController _scrollController = ScrollController();

   void _scrollToServices() {
     _scrollController.animateTo(
       AppSize.screenHeight / 2.4,
       duration: Duration(milliseconds: 600),
       curve: Curves.easeInOut,
     );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
         controller: _scrollController,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: AppSize.screenHeight/2.4,
                        width: AppSize.screenWidth,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                      Animate(
                        onPlay: (controller) => controller.repeat(),
                        child: Positioned(
                          top: 15,
                          left: 0,
                          right: 0,
                          child: Image.asset(
                            'assets/images/logos/logo.png',
                            height: AppSize.screenHeight / 3.6,
                          ),
                        ),
                      ).shake(
                        duration: GetNumUtils(3).seconds,
                        hz: 1,
                      ),
                      Positioned(
                        top: AppSize.screenHeight * .03,
                        left: 3,
                        right: 0,
                        child: Row(
                          children: [

                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Get.to(NotificationScreen());
                                Future.delayed(const Duration(seconds: 1), () {
                                  _notificationsController.updateUnreadCount();
                                });
                              },
                              icon: Obx(() {
                                final count = _notificationsController.unreadCount.value;

                                if (count == 0) {
                                  return const Icon(
                                    Iconsax.notification,
                                    color: Colors.white,
                                  );
                                }

                                return Badge(
                                  padding: EdgeInsets.all(AppSize.screenWidth * .01),
                                  label: Text(
                                    count > 9 ? '10+' : '$count',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  child: const Icon(
                                    Iconsax.notification,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),

                      // استخدام Column بدل Positioned منفصلة
                      Positioned(
                        top: AppSize.screenHeight / 3.9,
                        left: 16,
                        right: 16,
                        child: Column(
                          children: [
                            Text(
                              'اكتشف الخدمات التي تحتاجها، أو ابدأ رحلتك كمستقل \nوقدم عروضك على المشاريع المناسبة لك.',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20), // مسافة ثابتة ومرنة
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _scrollToServices();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      AppColors.secondaryColor,
                                    ),
                                  ),
                                  child: Text('استكشف الخدمات', style: TextStyle(color: Colors.white, fontSize: 19)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(StoreOrderScreen());
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      AppColors.primaryColor,
                                    ),
                                    side: WidgetStateProperty.all(
                                      BorderSide(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: Text('تصفح الأقسام', style: TextStyle(color: Colors.white, fontSize: 19)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSize.box(.02, 1),
                  Text('الأقسام الرئيسية',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 27),),
                  AppSize.box(.009, 1),
                  Text('اختر  من بين مجموعة واسعة من الأقسام',style: TextStyle(fontSize: 19)),
                  AppSize.box(.02, 1),
                  SizedBox(
                      height:AppSize.screenHeight/1.4,
                      child: (ServicesCategories())

                  ) ],
              ),

       )  );
  }
}
