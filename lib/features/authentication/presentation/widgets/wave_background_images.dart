import 'package:farmlynco/core/constant/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBackgroundImage extends StatelessWidget {
  const TopBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      width: 300.w,
      height: 350.h,
      child: const Image(
        image: AppImages.waves,
        fit: BoxFit.cover,
      ),
    );
  }
}

class BottomBackgroundImage extends StatelessWidget {
  const BottomBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image(fit: BoxFit.fill, image: AppImages.bottomWaves),
    );
  }
}
