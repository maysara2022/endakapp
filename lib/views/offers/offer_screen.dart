import 'package:endakapp/controllers/offers/offers_controller.dart';
import 'package:endakapp/controllers/orders/orders_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_process.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/models/offers/offer_model.dart';
import 'package:endakapp/views/chat/converstion_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OfferScreen extends StatelessWidget {
  final int serviceId;
  OfferScreen({super.key, required this.serviceId});

  final OrdersController _ordersController = Get.put(OrdersController());
  final OffersController _offersController = Get.put(OffersController());


  @override
  Widget build(BuildContext context) {
    // جلب البيانات أول مرة
    _ordersController.fetchMyOrderById(serviceId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض المتاحة'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (_ordersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final offers = _ordersController.orderOffers;
        final serviceTitle = _ordersController.selectedOrder.value?.title;

        if (offers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد عروض متاحة حالياً',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return OfferCard(
              offer: offer,
              serviceTitle: serviceTitle,
              serviceId: serviceId,
            );
          },
        );
      }),
    );
  }
}

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final String? serviceTitle;
  final int serviceId;

   const OfferCard({
    super.key,
    required this.offer,
    this.serviceTitle,
    required this.serviceId,
  });

  Color _getStatusColor() {
    switch (offer.status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'delivered':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (offer.status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'accepted':
        return 'مقبول';
      case 'delivered':
        return 'تم التسليم';
      case 'rejected':
        return 'مرفوض';
      default:
        return offer.status;
    }
  }

  Future<void> _handleAccept() async {
    final OffersController offerController = Get.put(OffersController());
    final OrdersController ordersController = Get.put(OrdersController());

    try {
      await offerController.acceptOffer(offer.id);
      await ordersController.fetchMyOrderById(serviceId);


    } catch (e) {
     return;
    }
  }

  Future<void> _handleReject() async {
    final OffersController offerController = Get.find<OffersController>();
    final OrdersController ordersController = Get.find<OrdersController>();

    try {
      await offerController.rejectOffer(offer.id);
      await ordersController.fetchMyOrderById(serviceId);


    } catch (e) {
     return;
    }
  }
  Future<void> _handleRate(int rat , String comment) async {
    final OffersController offerController = Get.find<OffersController>();
    final OrdersController ordersController = Get.find<OrdersController>();

    try {
      await offerController.rate(offer.id, rat, comment);
      await ordersController.fetchMyOrderById(serviceId);


    } catch (e) {
     return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Provider info and status
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor:AppColors.secondaryColor,
                  backgroundImage: offer.provider.avatar != null
                      ? NetworkImage(offer.provider.avatar ?? '')
                      : null,
                  child: offer.provider.avatar == null
                      ? Text(
                    offer.provider.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.provider.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (serviceTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          serviceTitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor()),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Price
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'السعر:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${offer.price} ﷼',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            // Notes if available
            if (offer.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.note_outlined, size: 16, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          'ملاحظات:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      offer.notes,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            // Rating if available
            if (offer.rating != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${offer.rating}/5',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (offer.review != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        offer.review!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Dates info
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateInfo(
                    icon: Icons.access_time,
                    label: 'تاريخ التقديم',
                    date: _formatDate(offer.createdAt),
                  ),
                ),
                FloatingActionButton(  backgroundColor:Colors.transparent,
                  elevation: 0,

                  onPressed: () async {
                    int id = await UserPrefs.getId();
                    Get.to(
                      ChatsScreen(
                        myUserId: id,
                        partnerId: offer.provider.id,
                      ),
                    );
                  },
                  child: Icon(
                    Iconsax.messages_copy,
                    size: 30,
                    color: AppColors.secondaryColor,
                  ),),
                if (offer.expiresAt != null)
                Expanded(
                    child: _buildDateInfo(
                      icon: Icons.event_busy,
                      label: 'تاريخ الانتهاء',
                      date: _formatDate(offer.expiresAt!),
                    ),
                  ),

              ],
            ),

            // Action buttons based on status
            if (offer.status.toLowerCase() == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleAccept,
                      icon: const Icon(Icons.check),
                      label: const Text('قبول'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleReject,
                      icon: const Icon(Icons.close),
                      label: const Text('رفض'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (offer.status.toLowerCase() == 'accepted') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AppProcess.showRatingDialog(
                          context,
                          onRattingSubmit: (rating, comment) {
                            _handleRate(rating, comment);

                          },
                        );
                      },
                      icon: const Icon(Icons.done_all, size: 22),
                      label: const Text(
                        'تسليم العرض',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[600],
                        side: BorderSide(color: Colors.blue[600]!, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo({
    required IconData icon,
    required String label,
    required String date,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}