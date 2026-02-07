import 'package:endakapp/controllers/offers/offers_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppProcess {

  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }

  static void warring(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.secondaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }

  static void showRatingDialog(BuildContext context , {required void Function(int rat , String comment)? onRattingSubmit}) {
    int rating = 0;
    TextEditingController opinionController = TextEditingController();
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'قيّم مزود الخدمة',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // النجوم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1;
                              errorMessage = '';
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'يجب عليك تقييم الخدمة',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // رسالة الخطأ
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // حقل الرأي
                    SizedBox(height: 8),

                    TextField(
                      controller: opinionController,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'اكتب رأيك هنا (اختياري)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),

                    // جملة تنبيهية
                  ],
                ),
              ),
              actions: [
                // زر الإلغاء
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                // زر الإرسال
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (rating == 0) {
                      setState(() {
                        errorMessage = 'يجب عليك تقييم الخدمة قبل الإرسال!';
                      });
                      return;
                    }

                      onRattingSubmit!(
                        rating,
                        opinionController.text,
                      );
                      Navigator.pop(context);

                  },
                  child: const Text(
                    'إرسال',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
