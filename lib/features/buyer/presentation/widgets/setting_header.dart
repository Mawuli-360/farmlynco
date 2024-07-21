import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingHeader extends StatelessWidget {
  const SettingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.29.sh,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(199, 221, 252, 243),
            Color.fromARGB(195, 53, 212, 204),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70.r),
          bottomRight: Radius.circular(70.r),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: 0.59.sw,
            padding: EdgeInsets.only(left: 25.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  body: "Mawuli Zigah",
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.location_city_outlined,
                      size: 22.h,
                      color: AppColors.primaryColor,
                    ),
                    4.horizontalSpace,
                    const CustomText(body: "Borteyman, Ghana", fontSize: 16),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.09.sh,
            right: 20.h,
            child: Container(
              height: 100.h,
              width: 100.h,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(116, 255, 255, 255),
                        spreadRadius: 1.r,
                        blurRadius: 0.r,
                        offset: Offset(2.h, 2.h)),
                  ],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        "https://www.thespruce.com/thmb/fghCcR0Sv_lrSIg1mVWS9U-b_ts=/4002x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-grow-watermelons-1403491-hero-2d1ce0752fed4ed599db3ba3b231f8b7.jpg",
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
