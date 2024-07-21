import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingScale extends StatelessWidget {
  const CustomLoadingScale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      width: 50.w,
      child: const LoadingIndicator(
        indicatorType: Indicator.lineScale,
        colors: [Colors.blue, AppColors.headerTitleColor],
      ),
    );
  }
}
