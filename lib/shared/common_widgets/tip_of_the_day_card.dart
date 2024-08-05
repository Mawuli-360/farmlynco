import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipOfTheDayCard extends StatelessWidget {
  const TipOfTheDayCard({
    super.key,
    required this.tip,
  });

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
          color: const Color.fromARGB(83, 136, 219, 193),
          border: Border.all(color: AppColors.green),
          borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Image(
            width: 45.w,
            height: 45.h,
            image: AppImages.tip,
          ),
          7.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                CustomText(
                  body: "Tip Of The Day",
                  fontSize: 17.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  body: tip,
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 90, 90, 90),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
