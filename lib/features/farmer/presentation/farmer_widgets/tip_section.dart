import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipSection extends StatelessWidget {
  const TipSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          body: "Tips",
          left: 10.h,
          bottom: 10.h,
          top: 10.h,
          color: AppColors.headerTitleColor,
          fontWeight: FontWeight.w500,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.h),
          padding: EdgeInsets.all(5.h),
          height: 115.h,
          decoration: BoxDecoration(
              color: const Color(0xffD0FFE3),
              border: Border.all(color: Colors.green),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.amber,
                    size: 25.h,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const CustomText(body: "Precision Irrigation"),
                    5.verticalSpace,
                    const CustomText(
                      body:
                          "Optimize water usage with precision\nirrigation systems, ensuring each plant receives the right amount",
                      fontSize: 13.5,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image(
                  image: AppImages.garden,
                  width: 80.h,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
