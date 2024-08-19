import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/main.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:lottie/lottie.dart';

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
              Container(
                height: 135.h,
                decoration: BoxDecoration(
                    color: AppColors.headerTitleColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.h),
                      bottomRight: Radius.circular(20.h),
                    )),
                child: Row(
                  children: [
                    10.horizontalSpace,
                    LottieBuilder.asset(
                      "assets/animations/farm.json",
                      height: 120.h,
                    ),
                    2.horizontalSpace,
                    const CustomText(
                      body:
                          "Harnessing IoT technologies\nenhances efficiency and\nconnectivity.",
                      fontSize: 16,
                      color: AppColors.white,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
              90.verticalSpace,
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IoTCard(
                    readings: '36',
                    symbol: '°C',
                    name: 'Temperature',
                    image: AppImages.thermometer,
                  ),
                  IoTCard(
                      readings: "10",
                      symbol: "%",
                      name: "Humidity",
                      image: AppImages.moist),
                ],
              ),
              20.verticalSpace,
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IoTCard(
                      readings: "10",
                      symbol: "m/s",
                      name: "Wind Speed",
                      image: AppImages.windPower),
                  IoTCard(
                      readings: "10",
                      symbol: "hPa",
                      name: "Pressure",
                      image: AppImages.pressure)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IoTCard extends StatelessWidget {
  const IoTCard({
    super.key,
    required this.readings,
    required this.symbol,
    required this.name,
    required this.image,
  });

  final String readings;
  final String symbol;
  final String name;
  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: AppColors.appBgColor,
      child: SizedBox(
          height: 110.h,
          width: 170.w,
          child: Row(
            children: [
              6.horizontalSpace,
              Image(
                image: image,
                height: 42.h,
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Row(
                    children: [
                      CustomText(
                        body: readings,
                        fontSize: 40,
                        color: AppColors.headerTitleColor,
                      ),
                      8.horizontalSpace,
                      CustomText(
                        body: symbol,
                        fontSize: 25,
                        color: AppColors.headerTitleColor,
                      ),
                    ],
                  ),
                  CustomText(
                    body: name,
                    fontSize: 16,
                    color: AppColors.headerTitleColor,
                  ),
                  10.verticalSpace,
                ],
              ),
            ],
          )),
    );
  }
}
