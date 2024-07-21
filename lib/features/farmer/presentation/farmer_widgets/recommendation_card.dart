import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendatioCard extends StatelessWidget {
  const RecommendatioCard({
    super.key,
    required this.title,
    required this.response,
  });

  final String title;
  final String response;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      padding: EdgeInsets.all(10.h),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: AppColors.appBgColor,
          border: Border.all(
            color: const Color.fromARGB(144, 50, 137, 122),
          ),
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(26, 0, 0, 0),
                spreadRadius: 1.5.h,
                blurRadius: 2.h),
          ]),
      child: Column(
        children: [
          CustomText(
            body: title,
            color: AppColors.headerTitleColor,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          CustomText(
            body: response,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
