import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/widgets/connection_faild.dart';
import 'package:endakapp/models/orders/my_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/order_card.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final OrdersController _ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<MyOrders>>(
      future: _ordersController.fetchMyOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ConnectionFailed(fun : (){ setState(() {
              });});
        }
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return const Center(child: Text('لا توجد بيانات'));
        }
        return RefreshIndicator(
          onRefresh: (){
             return Future.delayed(Duration(seconds: 1), () {
             setState(() {

             });
             });
            },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index){
                final order = orders[index];
                return OrderCard(
                  orderId: order.id??0,
                  category: order.category,
                  description: order.description,
                  title: order.category,
                  imageUrl: order.imageUrl,
                  metaTitle: order.metaTitle,
                  price: 0.0,
                  customField: order.customFields,
                  status: order.isActive??true,
                );
              }
          ),
        );
      } ,
    );

  }
}
