import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/views/chat/chat_screen.dart';
import 'package:endakapp/views/home/screens/home_screen.dart';
import 'package:endakapp/views/notification/screens/notification_screen.dart';
import 'package:endakapp/views/orders/screens/store/store_order_screen.dart';
import 'package:endakapp/views/orders/screens/view/my_orders_screen.dart';
import 'package:endakapp/views/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
     PersistentTabController controller = PersistentTabController(
        initialIndex: 0,
      );
      return PersistentTabView(
        context,
        controller: controller,
        screens: _buildScreens(),
        items: _navBarsItems(),

        hideNavigationBarWhenKeyboardAppears: false,
        confineToSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: kBottomNavigationBarHeight,
        padding: const EdgeInsets.only(top: 8),
        navBarStyle: NavBarStyle.style6,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
      );
    }

    List<Widget> _buildScreens() {
      return [
        HomeScreen(),
        MyOrdersScreen(),
        StoreOrderScreen(),
        ChatScreen(),
        UserProfileScreen()
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Iconsax.home_1),
          activeColorPrimary: AppColors.secondaryColor,
          inactiveColorPrimary: AppColors.primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Iconsax.square, size:25),
          activeColorPrimary: AppColors.secondaryColor,
          inactiveColorPrimary: AppColors.primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.add_circled_solid, size:45),
          activeColorPrimary: AppColors.primaryColor,
          inactiveColorPrimary: AppColors.primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Iconsax.message, size:25),
          activeColorPrimary: AppColors.secondaryColor,
          inactiveColorPrimary: AppColors.primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Iconsax.profile_circle, size:30),
          activeColorPrimary: AppColors.secondaryColor,
          inactiveColorPrimary: AppColors.primaryColor,
        ),
      ];
    }
}
