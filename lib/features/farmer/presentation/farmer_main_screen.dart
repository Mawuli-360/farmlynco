import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_landing_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_menu_screen.dart';
import 'package:farmlynco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

final placeName = StateProvider<String>((ref) => '');
final advice = StateProvider<String>((ref) => '');
final weatherCondition = StateProvider<String>((ref) => '');
final isLoadingWeather = StateProvider<bool>((ref) => false);

class FarmerMainScreen extends ConsumerStatefulWidget {
  const FarmerMainScreen({super.key});

  @override
  ConsumerState<FarmerMainScreen> createState() => _FarmerMainScreenState();
}

class _FarmerMainScreenState extends ConsumerState<FarmerMainScreen> {
  @override
  void initState() {
    super.initState();
    // PermissionHandle.requestPermissions(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(placeNameProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text("NO"),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: const Text("YES"),
              ),
            ],
          ),
        );
      },
      child: ZoomDrawer(
        controller: drawerController,
        mainScreenScale: 0.15,
        angle: 0,
        slideWidth: 275.w,
        showShadow: true,
        clipMainScreen: false,
        menuScreen: FarmerMenuScreen(
          controller: drawerController,
        ),
        mainScreen: const FarmerLandingScreen(),
        menuBackgroundColor: AppColors.headerTitleColor,
        mainScreenTapClose: true,
      ),
    );
  }
}
