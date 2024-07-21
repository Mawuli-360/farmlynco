import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/presentation/buyer_home_screen.dart';
import 'package:farmlynco/features/buyer/presentation/buyer_setting_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class BuyerLandingScreen extends ConsumerStatefulWidget {
  const BuyerLandingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BuyerLandingScreenState();
}

class _BuyerLandingScreenState extends ConsumerState<BuyerLandingScreen>
    with SingleTickerProviderStateMixin {
  late MotionTabBarController motionTabBarController;

  List<Widget> buyerScreens = [
    const BuyerHomeScreen(),
    const FavoriteScreen(),
    const BuyerSettingScreen()
  ];

  @override
  void initState() {
    motionTabBarController = MotionTabBarController(
        initialIndex: 0,
        length: 3,
        vsync: this,
        animationDuration: const Duration(milliseconds: 900));
    super.initState();
  }

  @override
  void dispose() {
    motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: motionTabBarController,
        initialSelectedTab: "Home",
        tabBarHeight: 65.h,
        tabSize: 60.h,
        labels: const ["Home", "Favourite", "Profile"],
        icons: const [
          Icons.store_mall_directory_rounded,
          Icons.favorite,
          Icons.person,
        ],
        onTabItemSelected: (int value) {
          setState(() {
            motionTabBarController.index = value;
          });
        },
        tabIconColor: AppColors.green,
        tabIconSize: 32.h,
        tabIconSelectedSize: 28.h,
        tabSelectedColor: const Color.fromARGB(183, 136, 219, 193),
        tabIconSelectedColor: AppColors.primaryColor,
        tabBarColor: Colors.white,
        textStyle: TextStyle(color: AppColors.primaryColor, fontSize: 14.sp),
      ),
      body: buyerScreens[motionTabBarController.index],
    );
  }
}
