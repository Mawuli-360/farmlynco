import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_widgets/recommendation_card.dart';
import 'package:farmlynco/main.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FarmerIotScreen extends ConsumerWidget {
  const FarmerIotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "IoT Monitor",
        leading: IconButton(
          onPressed: () => drawerController.toggle?.call(),
          icon: const Icon(
            Icons.menu,
            color: AppColors.headerTitleColor,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: 1.sh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 210.h,
                child: Stack(
                  children: [
                    Container(
                        // color: Colors.red,
                        // height: 350.h,
                        ),
                    Container(
                      height: 120.h,
                      decoration: BoxDecoration(
                          color: AppColors.headerTitleColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.h),
                            bottomRight: Radius.circular(20.h),
                          )),
                    ),
                    Positioned(
                      top: 70.h,
                      left: 10.h,
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: SizedBox(
                            height: 100.h,
                            width: 170.w,
                            child: Row(
                              children: [
                                Image(
                                  image: AppImages.thermometer,
                                  height: 42.h,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const CustomText(
                                          body: "32",
                                          fontSize: 40,
                                          color: AppColors.headerTitleColor,
                                        ),
                                        8.horizontalSpace,
                                        const CustomText(
                                          body: "°C",
                                          fontSize: 25,
                                          color: AppColors.headerTitleColor,
                                        ),
                                      ],
                                    ),
                                    const CustomText(
                                      body: "Temperature",
                                      fontSize: 16,
                                      color: AppColors.headerTitleColor,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    Positioned(
                      top: 70.h,
                      right: 10.h,
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: SizedBox(
                            height: 100.h,
                            width: 170.w,
                            child: Row(
                              children: [
                                Image(
                                  image: AppImages.moist,
                                  height: 42.h,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const CustomText(
                                          body: "10",
                                          fontSize: 40,
                                          color: AppColors.headerTitleColor,
                                        ),
                                        8.horizontalSpace,
                                        const CustomText(
                                          body: "m3",
                                          fontSize: 22,
                                          color: AppColors.headerTitleColor,
                                        ),
                                      ],
                                    ),
                                    const CustomText(
                                      body: "Moisture",
                                      fontSize: 16,
                                      color: AppColors.headerTitleColor,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      child: CustomText(
                        body:
                            "Harnessing IoT technologies enhances\nefficiency and connectivity.",
                        fontSize: 16,
                        color: AppColors.white,
                        textAlign: TextAlign.center,
                        left: 25.h,
                      ),
                    ),
                  ],
                ),
              ),
              const RecommendatioCard(
                title: 'Soil Temperature',
                response:
                    'Select your favorite social network and share our icons with your contacts or friends. If you don’t have these social networks, simply copy the link and paste it in the one you use.',
              ),
              20.verticalSpace,
              const RecommendatioCard(
                title: 'Soil Moisture',
                response:
                    'Select your favorite social network and share our icons with your contacts or friends. If you don’t have these social networks, simply copy the link and paste it in the one you use.',
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
