import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsUse extends StatelessWidget {
  const TermsUse({super.key, this.onClose});
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: AppSize.screenWidth,
        height: AppSize.screenHeight / 1.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
                Text(
                  'الشروط والأحكام',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,color: AppColors.primaryColor
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),

            const SizedBox(height: 10),

            // النص الكامل
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.cairo(
                      color: Colors.black,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'مرحباً بك في Endak!\n\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold,color: AppColors.primaryColor),
                      ),
                      const TextSpan(
                        text:
                        'باستخدامك لموقع Endak فإنك توافق على الشروط والأحكام التالية. نرجو قراءتها بعناية قبل البدء في استخدام خدماتنا.\n\n',
                      ),
                      TextSpan(
                        text: '1. قبول الشروط\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'يعتبر دخولك أو استخدامك لموقع Endak بمثابة موافقة كاملة منك على الالتزام بجميع الشروط والسياسات الخاصة بالموقع.\n\n',
                      ),
                      TextSpan(
                        text: '2. استخدام الموقع\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'يُسمح باستخدام الموقع فقط للأغراض القانونية والمشروعة، ويُمنع استخدامه في أي أنشطة مخالفة للقانون أو تسبب ضررًا للآخرين.\n\n',
                      ),
                      TextSpan(
                        text: '3. الحسابات والمسؤولية\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'أنت مسؤول عن سرية بيانات تسجيل الدخول الخاصة بك، وعن جميع الأنشطة التي تتم عبر حسابك. يحتفظ الموقع بحق إيقاف أي حساب يخالف القواعد.\n\n',
                      ),
                      TextSpan(
                        text: '4. الخدمات والضمانات\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'يُقدم موقع Endak خدماته بأعلى جودة ممكنة، ولكننا لا نضمن أن تكون الخدمة خالية من الأخطاء أو الانقطاعات التقنية.\n\n',
                      ),
                      TextSpan(
                        text: '5. سياسة الخصوصية\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'نحترم خصوصيتك ونحافظ على بياناتك الشخصية. يتم استخدام المعلومات فقط لتحسين تجربتك وتقديم خدمات أفضل.\n\n',
                      ),
                      TextSpan(
                        text: '6. حقوق الملكية الفكرية\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'جميع الحقوق محفوظة لموقع Endak. لا يجوز نسخ أو إعادة استخدام أي محتوى دون إذن خطي مسبق من إدارة الموقع.\n\n',
                      ),
                      TextSpan(
                        text: '7. التعديلات على الشروط\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'يحتفظ الموقع بحق تعديل هذه الشروط في أي وقت. سيتم إخطار المستخدمين بالتحديثات عبر الموقع أو البريد الإلكتروني.\n\n',
                      ),
                      TextSpan(
                        text: '8. إخلاء المسؤولية\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'Endak غير مسؤول عن أي خسائر أو أضرار مباشرة أو غير مباشرة ناتجة عن استخدام خدمات الموقع.\n\n',
                      ),
                      TextSpan(
                        text: '9. التواصل معنا\n',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                        'لأي استفسارات أو شكاوى يمكنك التواصل معنا عبر البريد الإلكتروني الرسمي للموقع.\n\n',
                      ),
                      const TextSpan(
                        text:
                        'باستخدامك للموقع، فإنك تقر بأنك قرأت وفهمت ووافقت على هذه الشروط والأحكام.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
