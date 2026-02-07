import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/widgets/connection_faild.dart';
import 'package:endakapp/models/orders/my_orders.dart';
import 'package:endakapp/views/orders/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilteredOrders extends StatefulWidget {
  int? category;
  int? city;
  int? subCategory;
  String? searchTerm;

   FilteredOrders({super.key, this.category, this.city, this.subCategory, this.searchTerm});

  @override
  State<FilteredOrders> createState() => _FilteredOrdersState();
}

final OrdersController _ordersController = Get.put(OrdersController());

class _FilteredOrdersState extends State<FilteredOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج البحث'),
      ),
      body: FutureBuilder<List<MyOrders>>(
        future: _ordersController.searchServices(category: widget.category,city: widget.city,searchTerm: widget.searchTerm,subCategory: widget.subCategory),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ConnectionFailed(
              fun: () {
                setState(() {});
              },
            );
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }
          return RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                setState(() {});
              });
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  orderId: order.id ?? 0,
                  category: order.category,
                  description: order.description,
                  title: order.category,
                  imageUrl: order.imageUrl,
                  metaTitle: order.metaTitle,
                  price: 0.0,
                  customField: order.customFields,
                  status: order.isActive ?? true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
