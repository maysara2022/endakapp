import 'dart:io';

import 'package:endakapp/controllers/auth/google/google_auth.dart';
import 'package:endakapp/controllers/auth/register/register_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_process.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:endakapp/views/home/screens/home_page.dart';
import 'package:endakapp/views/login/screens/login_screen.dart';
import 'package:endakapp/views/register/widgets/terms_sheet.dart';
import 'package:endakapp/views/register/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RxBool see = true.obs;
  final RxBool agree = false.obs;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final RegisterController _registerController = Get.put(RegisterController());
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
                Icon(
                  Iconsax.profile_add,
                  size: 50,
                  color: AppColors.secondaryColor,
                ),
                AppSize.box(.01, 0),
                Text(
                  'مرحباً بك في Endek!',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'هل لديك حساب بالفعل؟',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                AppSize.box(.02, 0),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(LoginScreen());
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
                    'تسجيل الدخول',
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
              spacing: 10,
              children: [
                CustomTextField(
                  label: 'الاسم كامل',
                  keyType: TextInputType.name,
                  controller: _nameController,
                  icon: Iconsax.user,
                ),
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  keyType: TextInputType.emailAddress,
                  controller: _emailController,
                  icon: Icons.email,
                ),
                CustomTextField(
                  label: 'رقم الهاتف',
                  keyType: TextInputType.phone,
                  controller: _phoneController,
                  icon: Icons.phone,
                ),
                Obx(
                  () => TextField(
                    obscureText: see.value,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      filled: false,
                      suffixIcon: IconButton(
                        onPressed: () {
                          see.value = !see.value;
                        },
                        icon: see.value
                            ? Icon(Iconsax.eye, color: AppColors.greyColor)
                            : Icon(
                                Iconsax.eye_slash,
                                color: AppColors.greyColor,
                              ),
                      ),
                      label: Text('كلمة المرور'),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: agree.value,
                        onChanged: (v) => agree.value = v!,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => TermsUse(
                            onClose: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: Text(
                        'أوافق على الشروط والأحكام',
                        style: GoogleFonts.cairo(
                          color: Colors.blueAccent,
                          fontSize: 19,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: AppSize.screenWidth,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool checkForms = checkFields();
                      if (checkForms && agree.value==true) {
                        await _registerController.register(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          passwordConfirmation: _passwordController.text.trim(),
                          phone: _phoneController.text.trim()
                        );
                        AppProcess.success('نجاح', 'تم إرسال رابط التحقق من الإيميل بنجاح');
                        AppProcess.warring('', 'قم بفتح الرابط المرسل الى البريد المدخل');
                        Get.to(LoginScreen());
                      }
                      return;
                    },
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.primaryColor,
                      ),
                    ),
                    child: Text(
                      'تسجيل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
             if(Platform.isAndroid)
             Visibility(
               visible: Platform.isAndroid,
               child: Column(children: [
                 AppSize.box(.02, 0),
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
                         'التسجيل بواسطة Google',
                         style: TextStyle(
                           color: AppColors.blackColor,
                           fontSize: 16,
                         ),
                       ),
                     ),
                   ),
                 ),
                 AppSize.box(.02, 0),
               ],),
             )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool checkFields() {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
         agree.value!=false
       ) {
      return true;
    }
    AppProcess.warring('', 'قم بالتأكد من البيانات المدخلة والموافقة الشروط والأحكام');
    return false;
  }
  void _initializeGoogleAuth(BuildContext context) {
    if (_googleAuth!= null) {
      return;
    }else{
      _googleAuth = GoogleAuth(
        onError: (error) {
          print("$error*************************");
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
