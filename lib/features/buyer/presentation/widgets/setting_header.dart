import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/user_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingHeader extends ConsumerWidget {
  const SettingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider);
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
                CustomText(
                  body: user?.name ?? "user",
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
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
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        user?.imageUrl ??
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png",
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
