import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/models/offers/offer_model.dart';
import 'package:endakapp/views/offers/offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewOrderScreen extends StatelessWidget {
  final int orderId;
  final String? imageUrl;
  final String? title;
  final String? description;
  final double? price;
  final String? category;
  final bool status;
  final String? metaTitle;
  final VoidCallback? onDetailsTap;
  final Map<String, dynamic>? customField;
 // final List<OfferModel> offers;


  const ViewOrderScreen({
    super.key,
    this.imageUrl,
    this.title,
    this.description,
    this.price,
    this.category,
    this.onDetailsTap,
    required this.status,
    this.customField,
    this.metaTitle,
    required this.orderId,
   // required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:  Text('تفاصيل الطلب'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المنتج الرئيسية
            _buildMainImage(),

            // معلومات المنتج الأساسية
            _buildBasicInfo(context),

            // الحقول المخصصة
            if (customField != null && customField!.isNotEmpty)
              _buildCustomFields(context),

            // زر التفاصيل
            if (onDetailsTap != null) _buildDetailsButton(context),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(OfferScreen(serviceId: orderId));

                },
                label: const Text(
                  'تصفح العروض',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImage() {
    return Container(
      height: 300,
      color: Colors.white,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'لا توجد صورة',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title ?? 'بدون عنوان',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusChip(),
            ],
          ),

          if (category != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 6),
                  Text(
                   metaTitle??category!,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (description != null) ...[
            const SizedBox(height: 20),
            const Text(
              'الوصف',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],

          if (price != null) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'السعر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${price!.toStringAsFixed(2)}',
                  style:  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status ? Colors.green[200]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: status ? Colors.green[700] : Colors.red[700],
          ),
          const SizedBox(width: 4),
          Text(
            status ? 'نشط' : 'غير نشط',
            style: TextStyle(
              color: status ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFields(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'معلومات إضافية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...customField!.entries.map((entry) {
            return _buildCustomFieldItem(entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCustomFieldItem(String key, dynamic value) {
    bool isImage = _isImageUrl(value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://endak.net/storage/"+value.toString(),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'فشل تحميل الصورة',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isImageUrl(dynamic value) {
    if (value == null || value is! String) return false;

    String urlString = value.toLowerCase().trim();

    if (!urlString.startsWith('services/custom_fields') && !urlString.startsWith('services/custom_fields')) {
      return false;
    }

    List<String> imageExtensions = [
      '.jpg', '.jpeg', '.png', '.gif',
      '.bmp', '.webp', '.svg', '.ico'
    ];

    return imageExtensions.any((ext) => urlString.endsWith(ext));
  }

  Widget _buildDetailsButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onDetailsTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 8),
            Text(
              'عرض المزيد من التفاصيل',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}