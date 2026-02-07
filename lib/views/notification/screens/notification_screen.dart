import 'package:endakapp/controllers/notifications/notifications_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/widgets/connection_faild.dart';
import 'package:endakapp/models/notifications/notifications_model.dart';
import 'package:endakapp/models/orders/my_orders.dart';
import 'package:endakapp/views/offers/single_offer.dart';
import 'package:endakapp/views/orders/screens/view/view_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../controllers/orders/orders_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationsController _notificationsController = Get.put(
    NotificationsController(),
  );
  final OrdersController _ordersController = Get.put(OrdersController());

  @override
  void dispose() {
    _notificationsController.markAllNotificationsAsRead();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsController.fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: ConnectionFailed(
                fun: () {
                  setState(() {});
                },
              ),
            );
          }
          final notification = snapshot.data ?? [];
          if (notification.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          return ListView.builder(
            padding: EdgeInsets.only(top: AppSize.screenHeight * .02),
            physics: BouncingScrollPhysics(),
            itemCount: notification.length,
            itemBuilder: (context, index) {
              final not = notification[index];
              return Padding(
                padding: EdgeInsets.all(AppSize.screenWidth * .02),
                child: Container(
                  padding: EdgeInsets.all(AppSize.screenWidth * .03),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSize.screenWidth * .02),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber.shade100,
                        ),
                        child: Icon(
                          Iconsax.notification,
                          color: AppColors.secondaryColor,
                        ),
                      ),

                      AppSize.box(0, .02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              not.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(not.message),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Get.to(
                                      SingleOffer(
                                        providerId: not.data.providerId,
                                        offerId: not.data.offerId,
                                        serviceId: not.data.serviceId,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'مشاهدة العرض',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final MyOrders? order =
                                        await _ordersController
                                            .fetchMyOrderById(
                                              not.data.serviceId,
                                            );
                                    if (order == null) {
                                      Get.snackbar(
                                        'خطأ',
                                        'هذه الخدمة غير متوفرة',
                                      );
                                      return;
                                    }
                                    print('orderId orderId ${order.id}');
                                    Get.to(
                                      () => ViewOrderScreen(
                                        orderId: order.id ?? 0,
                                        status: order.isActive ?? false,
                                        imageUrl: order.imageUrl,
                                        title: order.title,
                                        description: order.description,
                                        customField: order.customFields,
                                        category: order.category,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'عرض الخدمة',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.clock,
                                color: AppColors.secondaryColor,
                                size: 15,
                              ),
                              Text('  ${timeAgo(not.createdAt.toString())}'),
                            ],
                          ),
                          Visibility(
                              visible: not.readAt==null,
                              child: Text('●',style: TextStyle(color: Colors.blueAccent.shade400,fontSize: 30),)),
                          AppSize.box(.03, 0),

                          IconButton(
                            onPressed: () {
                              _notificationsController.deleteNotification(
                                not.id,
                              );
                              setState(() {});
                            },
                            icon: Icon(Iconsax.trash, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String timeAgo(String dateTimeString) {
    final date = DateTime.parse(dateTimeString).toLocal();
    final now = DateTime.now();

    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'منذ لحظات';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} من الأيام';
    } else if (diff.inDays < 30) {
      return 'منذ ${(diff.inDays / 7).floor()} أسبوع';
    } else if (diff.inDays < 365) {
      return 'منذ ${(diff.inDays / 30).floor()} شهر';
    } else {
      return 'منذ ${(diff.inDays / 365).floor()} سنة';
    }
  }
}

// Scaffold(
// body: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.notifications_off,size: 80,color: AppColors.greyColor,),
// Text('لا توجد إشعارات بعد',style: TextStyle(fontSize:25 ,fontWeight: FontWeight.bold),),
// Text('ستظهر هنا الإشعارات الجديدة عند وصولها',style: TextStyle(fontSize:25,color: AppColors.blackColor),),
// ],
// ),
// ),
// );
