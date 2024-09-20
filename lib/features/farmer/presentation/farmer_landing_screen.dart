import 'package:animations/animations.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_home_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_iot_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_marketplace.dart';
import 'package:farmlynco/features/farmer/presentation/farmers_providers/currentpage_provider.dart';
import 'package:farmlynco/features/farmer/presentation/weather/farmer_weather_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class FarmerLandingScreen extends ConsumerWidget {
  const FarmerLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final currentPageNotifier = ref.read(currentPageProvider.notifier);

    final List<Widget> items = [
      Icon(Iconsax.home_2, size: 35.h, color: Colors.white),
      Icon(Iconsax.cloud, size: 35.h, color: Colors.white),
      Icon(Icons.monitor, size: 35.h, color: Colors.white),
      Icon(Iconsax.shop, size: 35.h, color: Colors.white),
    ];

    final List<Widget> pages = [
      const FarmerHomeScreen(),
      const FarmerWeatherScreen(),
      const FarmerIotScreen(),
      const FarmerMarketPlace()
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageTransitionSwitcher(
        transitionBuilder: (
          child,
          primaryAnimation,
          secondaryAnimation,
        ) {
          return FadeTransition(
            opacity: primaryAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(primaryAnimation),
              child: child,
            ),
          );
        },
        duration: const Duration(milliseconds: 400),
        child: pages[currentPage],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.headerTitleColor,
        animationDuration: const Duration(milliseconds: 600),
        buttonBackgroundColor: AppColors.headerTitleColor,
        backgroundColor: AppColors.white,
        index: currentPage,
        items: items,
        onTap: (index) {
          currentPageNotifier.setPage(index);
        },
      ),
    );
  }
}
