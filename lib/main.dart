import 'package:easy_localization/easy_localization.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      systemNavigationBarColor: AppColors.primaryColor,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('ar'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: AppColors.primaryColor),

        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          scrolledUnderElevation: 1.0,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStateProperty.all(AppColors.whiteColor),
            iconSize: WidgetStateProperty.all(30),
          ),
        ),

        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.black),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          hintStyle: GoogleFonts.cairo(fontSize: 14),
          labelStyle: GoogleFonts.cairo(fontSize: 14),
        ),

        textTheme: TextTheme(
          bodyLarge: GoogleFonts.cairo(fontSize: 14),
          bodyMedium: GoogleFonts.cairo(fontSize: 14),
          labelLarge: GoogleFonts.cairo(fontSize: 14),
        ),

        listTileTheme: ListTileThemeData(
          minVerticalPadding: 0,
          titleTextStyle: GoogleFonts.cairo(fontSize: 14),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: GoogleFonts.cairo(fontSize: 14),
          ),
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: AppColors.primaryColor,
        //       foregroundColor: Colors.white,
        //       textStyle:  GoogleFonts.cairo(
        //           fontSize: 19
        //       ),
        //       minimumSize: Size(double.infinity, 50),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(5),
        //       ),
        //     )),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primaryColor,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
