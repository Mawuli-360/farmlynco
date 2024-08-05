import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_home_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_iot_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_marketplace.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_weather_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class FarmerLandingScreen extends ConsumerStatefulWidget {
  const FarmerLandingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FarmerLandingScreenState();
}

class _FarmerLandingScreenState extends ConsumerState<FarmerLandingScreen> {
  final List<Widget> items = [
    Icon(Iconsax.home_2, size: 35.h, color: Colors.white),
    Icon(Iconsax.cloud, size: 35.h, color: Colors.white),
    Icon(Icons.monitor, size: 35.h, color: Colors.white),
    Icon(Iconsax.shop, size: 35.h, color: Colors.white),
  ];

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const FarmerHomeScreen(),
      const FarmerWeatherScreen(),
      const FarmerIotScreen(),
      const FarmerMarketPlace()
    ];
    return Scaffold(
      backgroundColor: AppColors.white,
      body: pages[currentPage],
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.headerTitleColor,
        animationDuration: const Duration(milliseconds: 600),
        buttonBackgroundColor: AppColors.headerTitleColor,
        backgroundColor: AppColors.white,
        items: items,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
