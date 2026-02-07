import 'package:dio/dio.dart';
import 'package:endakapp/core/constants/app_process.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';

class OffersController {

  Future<void> acceptOffer(int offerId) async {
    final token = await UserPrefs.getToken();

    try {
    await Dio().post(
        'https://endak.net/api/v1/offers/$offerId/accept',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
    AppProcess.success('', 'تم قبول العرض');
    } on DioException catch (e) {
      AppProcess.error("خطأ", "تعذر قبول العرض , حاول لاحقاً");
      return;
    }
  }

  Future<void> rejectOffer(int offerId) async {
    try {
      final token = await UserPrefs.getToken();
      await Dio().post(
        'https://endak.net/api/v1/offers/$offerId/reject',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      AppProcess.warring('', 'تم رفض العرض');
    } on DioException catch (e) {
      AppProcess.error("خطأ", "تعذر رفض العرض , حاول لاحقاً");
      return;
    }
  }
  Future<void> deliverOffer(int offerId) async {
    try {
      final token = await UserPrefs.getToken();
      await Dio().post(
        'https://endak.net/api/v1/offers/$offerId/deliver',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      AppProcess.success('', 'تم تسليم المهمة , قم بقييم الخدمة');
    } on DioException catch (e) {
      AppProcess.error("خطأ", "تعذر تسليم المهمة , حاول لاحقاً");
      return;
    }
  }

  Future<void> rateOffer({
    required int offerId,
    required int rating,
    String? comment,
  }) async {
    try {
      final token = await UserPrefs.getToken();

      await Dio().post(
        'https://endak.net/api/v1/offers/$offerId/review',
        data: {
          'rating': rating,
          if (comment != null && comment.trim().isNotEmpty)
            'review': comment,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      AppProcess.success('', 'تم إرسال التقييم بنجاح');
    } on DioException catch (e) {
      AppProcess.error('خطأ', 'تعذر إرسال التقييم، حاول لاحقاً');
      return;
    }
  }


  Future<void> rate(int offerId,int rating,String comment) async {
    try {
      await deliverOffer(offerId);
      Future.delayed(Duration(seconds: 2), () {
      rateOffer(offerId: offerId, rating: rating,comment: comment);
        });
      AppProcess.warring('تم التقييم بنجاح', 'شكراً لوجودك معنا');
    }catch(e){
      AppProcess.error('', 'تعذر التقييم حاول لاحقاً');
      return;
      }
  }


}
