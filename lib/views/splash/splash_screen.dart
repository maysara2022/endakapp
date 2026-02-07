import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/views/home/screens/home_page.dart';
import 'package:endakapp/views/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToDestination();
  }

  Future<void> _navigateToDestination() async {
    String token = await UserPrefs.getToken();
    await Future.delayed(Duration(seconds: 3), () {});
    token.isEmpty?
    Get.offAll(LoginScreen()):Get.offAll(HomePage());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 80),
        decoration: BoxDecoration(
          color: AppColors.whiteColor
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Animate(
                onPlay: (controller) => controller.repeat(),
                child: Image.asset(
                  'assets/images/logos/logo.png',
                  height: AppSize.screenHeight / 3.6,
                ),
              ).shake(
                duration: Duration(seconds: 1),
                hz: .5,
              ),
             // Image.asset('assets/images/logos/logo.png',width: AppSize.screenWidth/2,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                  children: [
                    const TextSpan(text: 'شُبيك لُبّيك '),
                    TextSpan(
                      text: 'عنّدك',
                      style: GoogleFonts.cairo(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold, // اختياري
                      ),
                    ),
                    const TextSpan(
                      text: ' وبيّن ايدّيك , \nتَمتع الأن بالوصول لخَدمتك من جوالك و بكل سهولة',
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
