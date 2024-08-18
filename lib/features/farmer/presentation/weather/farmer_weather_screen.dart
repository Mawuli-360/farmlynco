import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_widgets/recommendation_card.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_widgets/spray_advice_card.dart';
import 'package:farmlynco/helper/extensions/language_extension.dart';
import 'package:farmlynco/main.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/language_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FarmerWeatherScreen extends ConsumerStatefulWidget {
  const FarmerWeatherScreen({super.key});

  @override
  ConsumerState<FarmerWeatherScreen> createState() =>
      _FarmerWeatherScreenState();
}

class _FarmerWeatherScreenState extends ConsumerState<FarmerWeatherScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  bool isForward = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
          isForward = false; // Animation is now reversing
        } else if (status == AnimationStatus.dismissed && !isForward) {
          _animationController.forward();
          isForward = true; // Animation is now forwarding again
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetLanguage = ref.watch(currentLanguage);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Weather",
        leading: IconButton(
          onPressed: () => drawerController.toggle?.call(),
          icon: const Icon(
            Icons.menu,
            color: AppColors.headerTitleColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(),
          SizedBox(
            width: double.infinity,
            height: 300.h,
            child: Image(
              image: AppImages.weatherBackground,
              fit: BoxFit.cover,
              color: const Color.fromARGB(163, 50, 137, 122),
              colorBlendMode: BlendMode.darken,
              height: double.infinity,
              width: double.infinity,
              alignment: FractionalOffset(animation.value, 0),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 500.h,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // 30.verticalSpace,
                  LottieBuilder.asset(
                    "assets/animations/forecast.json",
                    height: 120.h,
                    width: 150.h,
                    fit: BoxFit.cover,
                  ),
                  const RecommendationCard(
                    title: "Weather Insights",
                  ),
                  20.verticalSpace,
                  const SprayingAdviceCard(
                    title: "Spraying or Fertilizer Advice",
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 150.h,
            left: 60.h,
            right: 0,
            child: Row(
              children: [
                Image(
                  image: AppImages.location,
                  height: 60.h,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Device Location".translate(
                      targetLanguage,
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    const CustomText(
                      body: "Borteyman, Accra",
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
