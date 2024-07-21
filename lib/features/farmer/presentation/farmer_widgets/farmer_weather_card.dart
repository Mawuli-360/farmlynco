import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/custom_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCustomModalSheet(context),
      child: Card(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: SizedBox(
            height: 160.h,
            child: Row(
              children: [
                LottieBuilder.asset(
                  "assets/animations/forecast.json",
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.h),
                    child: const Column(
                      children: [
                        CustomText(
                          body: "Today's Weather",
                          color: AppColors.headerTitleColor,
                          top: 18,
                          bottom: 12,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        CustomText(
                            fontSize: 15,
                            maxLines: 4,
                            textOverflow: TextOverflow.ellipsis,
                            color: AppColors.primaryColor,
                            body:
                                "Working on custom designs might be very time consuming and complex in native Android and iOS development. Forget these painful days, as in Flutter, the CustomPaint widget combined with Flutters Hot Reload helps you to iterate upon your creations quickly and efficiently"),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
