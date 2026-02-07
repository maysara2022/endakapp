import 'package:endakapp/controllers/auth/google/google_auth.dart';
import 'package:endakapp/controllers/auth/login/login_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/views/home/screens/home_page.dart';
import 'package:endakapp/views/register/screens/Register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RxBool see = true.obs;

  final LoginController _loginController = LoginController();

  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _passwordEditingController = TextEditingController();

  // إضافة GoogleAuth
  GoogleAuth? _googleAuth;

  final RxBool isGoogleLoading = false.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: AppSize.screenWidth,
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: Column(
              spacing: 10,
              children: [
                AppSize.box(.04, 0),
                Icon(Iconsax.login, size: 50, color: AppColors.secondaryColor),
                AppSize.box(.01, 0),
                Text(
                  'أهلاً بعودتك',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ليس لديك حساب بعد؟',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                AppSize.box(.03, 0),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(RegisterScreen());
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.primaryColor,
                    ),
                    side: WidgetStateProperty.all(
                      BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                  child: Text(
                    'انشاء حساب جديد',
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
                AppSize.box(.02, 0),
              ],
            ),
          ),
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logos/logo.png',
                width: AppSize.screenWidth / 3.5,
              ),
              Text(
                'Endak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email, color: AppColors.greyColor),
                    label: Text('البريد الإلكتروني'),
                    filled: false,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                AppSize.box(.02, 0),
                Obx(
                      () => TextField(
                    controller: _passwordEditingController,
                    obscureText: see.value,
                    decoration: InputDecoration(
                      filled: false,
                      suffixIcon: IconButton(
                        onPressed: () {
                          see.value = !see.value;
                        },
                        icon: see.value
                            ? Icon(Iconsax.eye, color: AppColors.greyColor)
                            : Icon(Iconsax.eye_slash, color: AppColors.greyColor),
                      ),
                      label: Text('كلمة المرور'),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                AppSize.box(.04, 0),
                SizedBox(
                  width: AppSize.screenWidth,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final result = await _loginController.login(
                          _emailEditingController.text.trim(),
                          _passwordEditingController.text.trim(),
                        );

                        if (result['success'] == true) {
                          Get.to(HomePage());
                          await UserPrefs.saveToken(result['data']['token']);
                          await UserPrefs.saveId(result['data']['id']);
                        } else {
                          print('خطأ: ${result['message']}');
                        }
                      } catch (e) {
                        print('فشل تسجيل الدخول: $e');
                      }
                    },
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.primaryColor,
                      ),
                    ),
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                ),

                // إضافة فاصل "أو"
                AppSize.box(.03, 0),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.greyColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.greyColor)),
                  ],
                ),
                AppSize.box(.03, 0),

                Obx(
                      () => SizedBox(
                    width: AppSize.screenWidth,
                    child: ElevatedButton.icon(
                      onPressed: isGoogleLoading.value
                          ? null
                          : () async {
                        _initializeGoogleAuth(context);
                        isGoogleLoading.value = true;
                        if (_googleAuth == null) {
                          return;
                        }else{
                          await _googleAuth!.signIn();
                        }
                      },
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      icon: isGoogleLoading.value
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      )
                          : SvgPicture.asset('assets/images/google.svg'),
                      label: Text(
                        'تسجيل الدخول بواسطة Google',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                AppSize.box(.02, 0),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _initializeGoogleAuth(BuildContext context) {
    if (_googleAuth!= null) {
      return;
    }else{
      _googleAuth = GoogleAuth(
        onError: (error) {
          isGoogleLoading.value = false;
          Get.snackbar(
            'خطأ',
            'تعذر الدخول',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        },
        onUserChanged: (user) {
          if (user != null) {
          }
        },
        onAuthorizationChanged: (isAuthorized) {
        },
        onServerResponse: (data) async {
          isGoogleLoading.value = false;

          if (data['token'] != null) {
            await UserPrefs.saveToken(data['token']);
          }
          if (data['id'] != null) {
            await UserPrefs.saveId(data['id']);
          }

          Get.offAll(() => HomePage());

          Get.snackbar(
            'نجح',
            'تم تسجيل الدخول بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );

      _googleAuth!.initialize(
        serverClientId: '928333987956-ho44n3olpabs4gse3jsiue9bms9rsesl.apps.googleusercontent.com',
      );
    }


  }
}